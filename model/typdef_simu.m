clear ; 
% after default, the price of debt is recovery rate ->rr(st,bpol). In each period
% after default, the economy has prob mu to renegotiate (get bpr) and get reentry. 

format compact
simu_longpath  % simulate the model

%%
rows = 4;
cols = 3;

tb = 16; %periods before default
ta = 16; %periods after default

%% 2. after simulation, pick the data around default events
x1 = find(D==1); x1 = x1(x1>tb); xx=x1;
xx = xx(xx>=tb+1);
xx = xx(xx<=nos-ta);

trial = zeros(length(xx),tb+ta+1);  
bb = trial;  by = trial;  pm = trial;  tby = trial;  yy = trial;
cc = trial;  hh = trial;  zz = trial;  gov = trial;  fe = trial ;
ff = trial;  
% extract the sample within the 3-year interval aside a default event
for i = 1:length(xx)
    bb(i,1:tb+ta+1) =  B(xx(i)-tb:xx(i)+ta)';  % debt 
    by(i,1:tb+ta+1) = BY(xx(i)-tb:xx(i)+ta)'; % debt-GDP ratio
    pm(i,1:tb+ta+1) =  PM(xx(i)-tb:xx(i)+ta)'; % spread
    tby(i,1:tb+ta+1) =  TBY(xx(i)-tb:xx(i)+ta)'; % trade balance to GDP ratio
    yy(i,1:tb+ta+1) = Y(xx(i)-tb:xx(i)+ta)';  % output
    cc(i,1:tb+ta+1) =  C(xx(i)-tb:xx(i)+ta)';  % counsumption
    hh(i,1:tb+ta+1) =  H(xx(i)-tb:xx(i)+ta)'; % working hours
    zz(i,1:tb+ta+1) =  Z(xx(i)-tb:xx(i)+ta)'; % transitory growth rate
    gov(i,1:tb+ta+1) =  Gov(xx(i)-tb:xx(i)+ta)';
    ff(i,1:tb+ta+1) =  F(xx(i)-tb:xx(i)+ta)';
    fe(i,1:tb+ta+1) =  FE(xx(i)-tb:xx(i)+ta)';
end
%%
aa = 1:9;
qq = 1:0.25:9;

% Calculate mean default episodes
t = (-tb:ta);
func = @(x) mean(x);

ytilde_mean = func(yy) ;

c_mean = func(cc) ;

labour_mean = func(hh) ;

x = func(by);
dy_mean = x;

x = func(gov)*100;
gt_mean = x;

x = func(zz);
zt_mean = x;

x = func(pm);
pm_mean = x;

fe_mean = func(fe)*100;

tby_mean = func(tby);

d_mean = func(bb);

ff_mean = func(ff)*100;

%% Save results for illustration 
save typdef.mat ytilde_mean c_mean labour_mean dy_mean ff_mean d_mean ...
    tby_mean fe_mean zt_mean pm_mean gt_mean 

