function [ZZ,YY,CC,BadB,DD,PMPM,BB,HH,GG,FEFE,NB,NBY] = simu_irf(Ft,Zt,reentry,nos,Sim,T,tburn1,b,bp,bpr,default,f,q,rr,z,za,para)

% the output should be the differences btn shocked and unshocked pathes

%% Gov transfers rule
psi0 = para.psi0 ; % to match mean(f/y) = 14.7% 
tauh = para.tauh ;
tauc = para.tauc ;

%%
mu = para.mu ;  % prob of re-entry 
rbase = para.rbase; % baseline interest rate
coup = para.coup; % 0.03, long-term bond, coupon rate
eta = para.eta; % 1/eta quarters, long-term bond, average maturity
v = para.v ;

nb = length(b);
nz = length(z);

r_annual = ((1+rbase)^4-1)*100;
ZZ = zeros(nos,Sim);    YY = zeros(nos,Sim);    CC = zeros(nos,Sim);  
BadB = zeros(nos,Sim);  DD = zeros(nos,Sim);    PMPM = zeros(nos,Sim);   
BB = zeros(nos,Sim);    HH = zeros(nos,Sim);    FEFE = zeros(nos,Sim);  
GG = zeros(nos,Sim);    NB = zeros(nos,Sim);

for s = 1:Sim
    
  Bad = zeros(T,1);   D = zeros(T,1);   Z = zeros(T,1);  Y = zeros(T,1); 
  C = zeros(T,1);     H = zeros(T,1);   B = zeros(T,1);  PM = zeros(T,1);  
  FE = zeros(T,1);     Q = zeros(T,1);  G = zeros(T,1);  Netb = zeros(T,1); 

  bad = 0;
  ib = floor(nb/3);
  
  for t = 1:T
    
    [~,iz] = min(abs(z - Zt(t,s))) ;
    [~,ife] = min(abs(f - Ft(t,s))) ;
    is = (ife - 1)*nz + iz ;
    
    ir = reentry(t,s);  %for re-entry
    B(t) = b(ib);
    deff = default(is,ib);
    FE(t) = f(ife) ;

    if (bad==0) && (deff==0) % 1. good record, choose to repay debt
        Z(t) = z(iz);
        D(t) = 0;
        Bad(t) = 0;
        pol = bp(is,ib);
        Q(t) = q(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh) ./ exp(z(iz)) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh)./ exp(z(iz)) ).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh)*exp(z(iz)).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = exp(z(iz)) *H(t) ;
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - psi0 - FE(t) ;
        G(t) = min(g_resource, g_fiscal) + q(is,pol)*(b(pol)-(1-eta)*b(ib)) ...
                 - (eta + (1-eta)*coup)*b(ib) ;
        Netb(t) = q(is,pol)*(b(pol)-(1-eta)*b(ib)) - (eta + (1-eta)*coup)*b(ib) ;
    end

    if (bad==0) && (deff==1) % 2. good record, choose to default (pol=id) and fall into autarky
        Z(t) = za(iz) ;
        D(t) = 1;
        Bad(t) = 0;
        pol = ib;  % no new borrowing and no haircut/bargaining
        Q(t) = rr(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh) ./ exp(za(iz)) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh)./ exp(za(iz)) ).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh)*exp(za(iz)).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = exp(za(iz)) *H(t) ;
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - psi0 - FE(t) ;
        G(t) = min(g_resource, g_fiscal) ;
        Netb(t) = 0 ;
    end

    if (bad==1) && (ir>mu) % 3. bad record, autarky and no bargaining
        Z(t) = za(iz) ;
        D(t) = 0;
        Bad(t) = 1;
        pol = ib;  % no new borrowing and no haircut/bargaining
        Q(t) = rr(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh ) ./ exp(za(iz)) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh )./ exp(za(iz)) ).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh )*exp(za(iz)).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = exp(za(iz)) *H(t) ;
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - psi0 - FE(t) ;
        G(t) = min(g_resource, g_fiscal) ;
        Netb(t) = 0 ;
    end

    if (bad==1) && (ir<=mu) && (deff==0) % 4. bad record, reenter, bargain and not to default
        Z(t) = z(iz) ;
        D(t) = 0;
        Bad(t) = 0;
        pol = bpr(is);   % new debt outstanding, after haircut
        Q(t) = q(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh ) ./ exp(z(iz)) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh )./ exp(z(iz)) ).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh )*exp(z(iz)).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = exp(z(iz))*H(t) ;
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - psi0 - FE(t) ;
        G(t) = min(g_resource, g_fiscal) + q(is,pol)*(b(pol)-(1-eta)*b(ib)) ...
                 - (eta + (1-eta)*coup)*b(ib) ;
        Netb(t) = q(is,pol)*(b(pol)-(1-eta)*b(ib)) - (eta + (1-eta)*coup)*b(ib) ;
    end

    if (bad==1) && (ir<=mu) && (deff==1) % 5. bad record, reenter, bargain and to default (not happy with bargaining)
        Z(t) = za(iz) ;
        D(t) = 0 ;
        Bad(t) = 1;
        pol = ib;  % new debt outstanding, after haircut
        Q(t) = rr(is,pol);
        H(t) = ( -(psi0 + f(ife)) / (1-tauh ) ./ exp(za(iz)) + ...
            sqrt( ((psi0 + f(ife))/(1-tauh )./ exp(za(iz))).^2 + 4/v )) / 2 ; 
        C(t) = ( (1-tauh )*exp(za(iz)).*H(t) + psi0 + f(ife) ) / (1+tauc) ;
        Y(t) = exp(za(iz)) *H(t) ;
        g_resource = Y(t) - C(t) ;
        g_fiscal = tauc*C(t) + tauh*Y(t) - psi0 - FE(t) ;
        G(t) = min(g_resource, g_fiscal) ;
        Netb(t) = 0 ;
    end
    
    ib = pol;
    PM(t) = (((eta+(1-eta)*coup)/Q(t)+1-eta )^4-1)*100 - r_annual; % country risk premium
    bad = Bad(t) + D(t);     % if bad > 1; error("Credit record wrong"); end   
  end

  BadB(:,s) = Bad(tburn1:T-1);  ZZ(:,s) = Z(tburn1:T-1);     DD(:,s) = D(tburn1:T-1); 
  YY(:,s) = Y(tburn1:T-1);      CC(:,s) = C(tburn1:T-1);     HH(:,s) = H(tburn1:T-1);     
  BB(:,s) = B(tburn1:T-1);      PMPM(:,s) = PM(tburn1:T-1);  FEFE(:,s) = FE(tburn1:T-1);   
  GG(:,s) = G(tburn1:T-1);      NB(:,s) = Netb(tburn1:T-1);  
end

NBY = NB ./ YY ;

end

