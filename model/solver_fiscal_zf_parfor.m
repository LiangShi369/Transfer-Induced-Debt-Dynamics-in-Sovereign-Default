function [bp,bpr,default,probdef,q,rr,vp,vd,za] = solver_fiscal_zf_parfor(b,f,z,pdf,para)


phi0 = para.phi0 ;    phi1 = para.phi1;   alfa = para.alfa;   betta = para.betta; 
psi0 = para.psi0;     psi1 = para.psi1;   sigg_bpr = para.sigg_bpr;    sigg_bp=para.sigg_bp;
sigg_defp=para.sigg_defp;  mu = para.mu;  rbase = para.rbase ;
coup = para.coup ;     eta = para.eta ;    tauc = para.tauc ;   tauh = para.tauh ;
v = para.v ;
 
%%
nz = length(z);
nf = length(f);
nb = length(b);
ns = nz*nf; % number of grids for exogenous shocks
za = exp(z) - max(0, -phi0*exp(z) + phi1*exp(z).^2);  % TFP loss function
za = log(za);

zz = repmat(z,nf,1);   % norm(zz - zz1)
zaza = repmat(za,nf,1);  % norm(zaza - zaza1)
fe = repmat(f',nz,1); fe = fe(:);  % norm(ge1 - ge)
zz = exp(zz) ; 
zaza = exp(zaza) ;

%% consumption and labour
% to solve h* = (-(psi0+fe)/(1-tauh+psi1)/zz + sqrt( ((psi0+fe)/(1-tauh)/zz)^2 + 4/v ))/2 , 
h = (-(psi0+fe)/(1-tauh+psi1)./zz + sqrt( ((psi0+fe)/(1-tauh+psi1)./zz).^2 + 4/v ))/2 ; 
u_h = - v*(h).^2/2 ; 
c = ((1-tauh+psi1)*zz.*h + psi0 + fe) / (1+tauc) ;
y_minus_c = zz.*h - c ;
tax_minus_f = tauc*c + tauh*zz.*h - psi0 - psi1*zz.*h - fe ;
g_temp = min(y_minus_c,tax_minus_f) ;  % g_temp = y_minus_c - tax_minus_f ;
u_c = log(c) ; 
uc_plus_uh = u_c + u_h ;

%% autarky
ha = (-(psi0+fe)/(1-tauh+psi1)./zaza + sqrt( ((psi0+fe)/(1-tauh+psi1)./zaza).^2 + 4/v ))/2 ; 
ca = ((1-tauh+psi1)*zaza.*ha + psi0 + fe) / (1+tauc) ;
ga_resource = zaza.*h - ca ;
ga_fiscal = tauc*ca + tauh*zaza.*ha - psi0 - psi1*zaza.*ha - fe ;  % ga_resource - ga_fiscal ; 
ga = min(ga_fiscal, ga_resource) ;

% ua = log(ca) - v*(ha).^2/2 + log(ga) ;
ua = zeros(ns,1) ;
for is = 1:ns
    if ga(is) > 0 
        ua(is) = log(ca(is)) - v*(ha(is)).^2/2 + log(ga(is)) ;
    else
        ua(is) = - Inf ; 
    end
end

dist = 1;    vaut = zeros(ns,1); %value of autarky
while dist > 1e-7
    vautnew = ua + betta*pdf*vaut; 
    dist = max(abs(vautnew(:)-vaut(:)));
    vaut = vautnew;
end  

fprintf('vaut solved \n' );

%% to incorporate taste shocks
epsi = 10e-16;
cv_bpr = sigg_bpr*log(epsi);  % critical value

probDcre = zeros(ns,1);
probVp = zeros(ns,1);
cv_bp = sigg_bp*log(epsi); % critical value

%% Initialize the Value functions
V = zeros(ns,nb);  %continue repaying
vp = zeros(ns,nb); %the value of good standing
vpnew = vp;
vd = zeros(ns,1); %value of default

bp = zeros(ns,nb); %debt policy function (expressed in indices)  
bpr = zeros(ns,1); % debt policy (index) when decided renegotiate (right after every default)
q = ones(ns,nb)/(1+rbase); %initial price of debt
qnew = zeros(ns,nb);
rr = 0.5*ones(ns,nb)/(1+rbase);
probdef = zeros(ns,nb);

WW = zeros(nb,ns) ;
Gamma = zeros(ns,1) ;
Dcre = zeros(ns,nb) ;
dampen = 0.85 ;

%% Execute the VFI
diff = 1;    its = 1;
tol = 1e-6;    maxits = 1000;
smctime = tic;  totaltime = 0;

while diff > tol && its< maxits

ev = betta*pdf*V;

parfor is = 1:ns
    W = zeros(nb,1,'double') ;
    for ib = 1:nb
        bib = b(ib) ;
        for ibp = 1:nb
            if q(is,ibp) > 0.40
                g = g_temp(is) + ( b(ibp)-(1-eta)*bib ) .* q(is,ibp) - ...
                    ( eta+(1-eta)*coup ) * bib ; 
                if g > 0
                    W(ibp) = uc_plus_uh(is) + log(g) + ev(is,ibp) ;
                else
                    W(ibp) = - Inf ;
                end
            else
                W(ibp) = - Inf ;
            end
        end
        [vpnew(is,ib), bp(is,ib)]  = max( W ) ;

        sumExp = 0;
        sumExpQ = 0;
        for ibp = 1 : nb
            temp = W(ibp) - vpnew(is, ib) - cv_bp ; 
            if temp > 0
              theExp = exp((temp + cv_bp) / sigg_bp);  % Compute theExp
              sumExp = sumExp + theExp;               % Accumulate theExp
              sumExpQ = sumExpQ + theExp * q(is, ibp);  % Accumulate theExpQ
            end
        end
        qnew(is,ib) = eta + (1-eta) * (coup + sumExpQ / sumExp) ;
    end
end

parfor is = 1:ns 
    maxWW = -inf;  % To store the maximum value of WW
    for ib = 1:nb 
        Dsov = max(0, vpnew(is,ib) - vaut(is));
        Dcre(is,ib) = (eta + (1-eta)*(coup + q(is,bp(is,ib)) ) ).*b(ib);
        WW(ib,is) = Dsov^alfa * Dcre(is,ib)^(1-alfa);
        if WW(ib,is) > maxWW
            maxWW = WW(ib,is);  % Update maximum value
        end
    end
    Gamma(is) = maxWW; 
end


parfor is = 1:ns
    sumExp = 0;
    probDcre_is = 0;
    probVp_is = 0;
    for ib = 1:nb
        temp = WW(ib, is) - Gamma(is) - cv_bpr;
        if temp > 0
            theExp = exp((temp + cv_bpr) / sigg_bpr);
            sumExp = sumExp + theExp;  % Accumulate sums directly
            probDcre_is = probDcre_is + theExp * Dcre(is, ib);
            probVp_is = probVp_is + theExp * vpnew(is, ib);
        end
    end
    if sumExp > 0
        probDcre(is) = probDcre_is / sumExp;
        probVp(is) = probVp_is / sumExp;
    else
        probDcre(is) = 0;
        probVp(is) = 0;
    end
end
  
  vdnew = ua + betta*pdf*( mu*probVp + (1-mu)*vd );

  probdef = 1 ./ ( 1 + exp((vpnew - vdnew)/sigg_defp) ); % prob of default

  rr = pdf*((1-mu)*rr + mu*probDcre./b')/(1 + rbase); 

  qnew = pdf*(probdef.*rr + (1-probdef).*qnew)/(1 + rbase);

  % dampen debt price schedule
  qnew = dampen*qnew + (1-dampen)*q ;

  diff = max(max(abs(qnew-q))) + max(max(abs(vpnew-vp))) + max(max(abs(vdnew-vd)));

  q = qnew;
  vp = vpnew;
  vd = vdnew;
  V = max(vp,repmat(vd,1,nb));

totaltime = totaltime + toc(smctime);
avgtime   = totaltime/its;

if mod(its, 50) == 0
    fprintf('%4.0f ~%4.7f ~%4.5fs ~%4.5fs \n', its, diff, totaltime, avgtime);
end

its = its+1;
smctime = tic; % re-start clock

end


default = vp < repmat(vd,1,nb);


parfor is = 1:ns 

    maxWW = -inf;  % Initialize maximum WW
    maxIdx = 1;    % Initialize index for maximum WW

    for ib = 1:nb 
        Dsov = max(0, vpnew(is, ib) - vaut(is));
        Dcre1 = (eta + (1 - eta) * (coup + q(is, bp(is, ib)))) * b(ib);
        WW1 = Dsov^alfa * Dcre1^(1 - alfa);

        if WW1 > maxWW
            maxWW = WW1;
            maxIdx = ib;
        end
    end
    bpr(is) = maxIdx ;

end


end


