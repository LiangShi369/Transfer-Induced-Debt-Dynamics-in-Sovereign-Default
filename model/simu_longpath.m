clear ; 
% after default, the price of debt is recovery rate ->rr(st,bpol). In each period
% after default, the economy has prob mu to renegotiate (get bpr) and get reentry. 
load fiscal_zf2.mat

format compact
phi0 = para.phi0 ;    phi1 = para.phi1;   alfa = para.alfa;   betta = para.betta; 
psi0 = para.psi0;     psi1 = para.psi1;   sigg_bpr = para.sigg_bpr;    sigg_bp=para.sigg_bp;
sigg_defp=para.sigg_defp;  mu = para.mu;   chi = para.chi ;  rbase = para.rbase ;
coup = para.coup ;    eta = para.eta ;    tauc = para.tauc ;   tauh = para.tauh ;
% psi0_g = para.psi0_g ;  psi1_g = para.psi1_g ;  psi2_g = para.psi2_g ;  
v = para.v ;

z = exp(z) ;
za = exp(za) ;

%%
rng(211)

nos = 2000000;
T = 2100000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vectors in t = 1:T loop 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z = zeros(T,1);    Y = zeros(T,1);    C = zeros(T,1);  
H = zeros(T,1);    Bad = zeros(T,1);  Q = zeros(T,1);    
B = zeros(T,1);    D = zeros(T,1);    % default with good record
PM = zeros(T,1);   Gov = zeros(T,1);
FE = zeros(T,1);   F = zeros(T,1) ;   % transfers payment
f_residual = F ;
Re = zeros(T,1);   % indicator for re-entry
Cut = zeros(T,1); % haircut ratio
r_annual = ((1+rbase)^4-1)*100;


% codegen simu_func -args {pdfz,T} -o simu_func_mex2
% zpath = simu_func_mex(pdfz,T) ; % generate shocks
% fpath = simu_func_mex(pdff,T) ;
tic
    
bad = 0;
ib = floor(nb/3);
reentry = rand(T,1);
zpath = simu_func(pdfz,T)  ;
fpath = simu_func(pdff,T) ; 
  
for t = 1:T
    
    iz = zpath(t);
    ife = fpath(t);
    is = (ife-1)*nz + iz ;
    
    B(t) = b(ib);
    ir = reentry(t);  %for re-entry

    if (bad==0) && (default(is,ib)==0) % 1. good record, choose to repay debt
        Z(t) = log(z(iz));
        D(t) = 0;
        Bad(t) = 0;
        pol = bp(is,ib);
        Q(t) = q(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh+psi1) ./ z(iz) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh+psi1)./z(iz)).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh+psi1)*z(iz).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = z(iz)*H(t) ;
        F(t) = psi0 + psi1*Y(t) + f(ife) ;
        FE(t) = f(ife);
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - F(t) ;
        Gov(t) = min(g_resource, g_fiscal) + q(is,pol)*(b(pol)-(1-eta)*b(ib)) ...
                 - (eta + (1-eta)*coup)*b(ib) ;
        Re(t) = 0;
    end

    if (bad==0) && (default(is,ib)==1) % 2. good record, choose to default (pol=id) and fall into autarky
        Z(t) = log(za(iz)) ;
        D(t) = 1;
        Bad(t) = 0;
        pol = ib;  % no new borrowing and no haircut/bargaining
        Q(t) = rr(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh+psi1) ./ za(iz) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh+psi1)./za(iz)).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh+psi1)*za(iz).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = za(iz)*H(t) ;
        F(t) = psi0 + psi1*Y(t) + f(ife) ;
        FE(t) = f(ife);
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - F(t) ;
        Gov(t) = min(g_resource, g_fiscal) ;
        Re(t) = 0; 
    end

    if (bad==1) && (ir>mu) % 3. bad record, autarky and no bargaining
        Z(t) = log(za(iz)) ;
        D(t) = 0;
        Bad(t) = 1;
        pol = ib;  % no new borrowing and no haircut/bargaining
        Q(t) = rr(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh+psi1) ./ za(iz) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh+psi1)./za(iz)).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh+psi1)*za(iz).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = za(iz)*H(t) ;
        F(t) = psi0 + psi1*Y(t) + f(ife) ;
        FE(t) = f(ife);
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - F(t) ;
        Gov(t) = min(g_resource, g_fiscal) ;
        Re(t) = 0;
    end

    if (bad==1) && (ir<=mu) && (default(is,ib)==0) % 4. bad record, reenter, bargain and not to default
        Z(t) = log(z(iz)) ;
        D(t) = 0;
        Bad(t) = 0;
        pol = bpr(is);   % new debt outstanding, after haircut
        Q(t) = q(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh+psi1) ./ z(iz) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh+psi1)./z(iz)).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh+psi1)*z(iz).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = z(iz)*H(t) ;
        F(t) = psi0 + psi1*Y(t) + f(ife) ;
        FE(t) = f(ife);
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - F(t) ;
        Gov(t) = min(g_resource, g_fiscal) + q(is,pol)*(b(pol)-(1-eta)*b(ib)) ...
                 - (eta + (1-eta)*coup)*b(ib) ;
        Re(t) = 1;  
        Cut(t) = 1 - b(bpr(is))/b(bp(is,ib));
    end

    if (bad==1) && (ir<=mu) && (default(is,ib)==1) % 5. bad record, reenter, bargain and to default (not happy with bargaining)
        Z(t) = log(za(iz)) ;
        D(t) = 0;
        Bad(t) = 1;
        pol = ib;  % new debt outstanding, after haircut
        Q(t) = rr(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh+psi1) ./ za(iz) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh+psi1)./za(iz)).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh+psi1)*za(iz).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = za(iz)*H(t) ;
        F(t) = psi0 + psi1*Y(t) + f(ife) ;
        FE(t) = f(ife);
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - F(t) ;
        Gov(t) = min(g_resource, g_fiscal) ;
        Re(t) = 0;  
    end
    
    ib = pol;
    PM(t) = (((eta+(1-eta)*coup)/Q(t)+1-eta )^4-1)*100 - r_annual; % country risk premium
    bad = Bad(t) + D(t); 
    if bad > 1; error("Credit record wrong"); end   
end

toc

dy1 = B./Y*100;       
nx = (B(2:T)-(1-eta)*B(1:T-1)).*Q(1:T-1) - (eta+(1-eta)*coup)*B(1:T-1);

%%%%%% eliminate burning period %%%%%% 
Z = exp(Z(T-nos:T-1));     
TBY = nx(T-nos:T-1)./Y(T-nos:T-1);
C = C(T-nos:T-1);   
H = H(T-nos:T-1); 
B = B(T-nos:T-1);            
BY = dy1(T-nos:T-1);  
Y = Y(T-nos:T-1);

Gov = Gov(T-nos:T-1);
F = F(T-nos:T-1);
FE = FE(T-nos:T-1);
Bad = Bad(T-nos:T-1);
D = D(T-nos:T-1);   
PM = PM(T-nos:T-1); 



