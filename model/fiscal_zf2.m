clear;

format compact

%% parameters to calibrate
para.phi0 = 0.282 ; 
para.phi1 = 0.324 ; 
para.alfa = 0.64 ;  % borrower's bargaining power
para.betta = 0.9757 ; % discount factor

% Transfers rule: f_t = psi0 + psi1*y_t + epsilon_t
para.psi0 = 0.14 ;  % to match mean(f/y) = 14.7% 
para.psi1 = 0 ;   % corr(ff,yy) = 0.26

%% parameters for state variables
nz = 25 ;   % # grids of TFP                  
nf = 25 ;   % # grids of govt spending shock  
nb = 250;  % # of grid points for debt   

rhoz = 0.90 ;   
sdz = 0.0195 ;   % stdev of log(cyc_y) = 0.03
rhof = 0.95 ;    % autocorrelation of g^e process
sdf = 0.0073 ;   % std(f) = 0.0276
bupper = 0.95 ;  % debt grid 
   
std_z = sdz/sqrt(1-rhoz^2) ;
std_f = sdf/sqrt(1-rhof^2) ;

%% parameters for taste shocks
para.sigg_bpr = 0.0025;  % for renegotiation
para.sigg_bp = 0.0025;   % for debt policy in good status
para.sigg_defp = 0.0025; % for default decision

%% pre-set parameters
para.mu = 0.0385;  % prob of re-entry 
para.chi = 1;     % inverse of Frisch elasticity
para.rbase = 0.01; % baseline interest rate
para.coup = 0.0125; % long-term bond, coupon rate
para.eta = 0.035; % 1/eta quarters, long-term bond, average maturity

% tax rules
para.tauc = 0.15 ; 
para.tauh = 0.33 ;
para.v = (1-para.tauh) / (1-para.tauh) / (1 + para.psi0 + para.psi1 ) ;

%% endowment grids
width = 3.8 ;  % 3.7 (two-tail) sigma both sides covers 99.98% of the distribution
[z,pdfz] = tauchen(nz,0,rhoz,sdz,width);
[f,pdff] = tauchen(nf,0,rhof,sdf,width);

%% debt grids
blower = 0.35 ;
b = blower:(bupper-blower)/(nb-1):bupper; 
b = b(:); 

%% Probability transition matrix 
ns = nz*nf;
pdf = kron(pdff,pdfz); %Joint distribution, each g includes all t grids, is = (ig-1)*nt+it
pdf = pdf./(((sum(pdf,2)))*ones(1,ns));  % norm(pdf-pdf0)

%% Generate C code to speedup solving
% cfg = coder.config('mex');
% cfg.GenerateReport = true;
% codegen -config cfg solver_fiscal_zf_parfor -args {b,f,z,pdf,para} -o solver_fiscal_zf_parfor_mex

% solve the dynamic programming problem 
[bp,bpr,default,probdef,q,rr,vgood,vbad,za] = solver_fiscal_zf_parfor_mex(b,f,z,pdf,para);

%% Save solutions 
vdiff = vgood - vbad;
vbad = repmat(vbad,1,nb);

zz = repmat(z,nf,1);
fe = repmat(f',nz,1); fe = fe(:);

save fiscal_zf2.mat para b bp bpr default f nf nz nb pdff pdfz q rr rhof rhoz ...
    sdf sdz vbad vgood width z za probdef


