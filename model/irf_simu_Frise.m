clear

% Warning: can take quick a while to complete...

format compact
load fiscal_zf2.mat f rhof sdf z rhoz sdz b bp bpr default q rr za para

%% define parameters
tburn1 = 600;  % periods to be burnt for model simulation
tburn2 = 200;  % periods to be burnt for shocks
Sim = 6000;    % 20000 
number = 500;  % number of repititions
nos = 55;
shock = 0.0078;  %std_f = 0.0234

z_low = - 0.02;
z_high = 0.02;
b_bound_high = 0.64 ;
b_bound_low = 0.60 ;

T = tburn1 + nos; 
reentry = rand(T,Sim);  % prob of re-entry after default

[~,ife] = sort(abs(f - shock)); % find the nearest state of g grid to shock
f1 = f(ife(1)); % 1st nearest value
f2 = f(ife(2)); % 2nd nearest value
lambda = (shock-f2)/(f1-f2); % g1 path takes lamb weight, g2 path takes (1-lamb) weight

ff1 = @(FF1,FF2,FF_un,x1) mean(lambda*FF1(:,x1)+(1-lambda)*FF2(:,x1)-FF_un(:,x1),2);
ff2 = @(FF1,FF2,FF_un,x1) mean(lambda*FF1(:,x1)+(1-lambda)*FF2(:,x1)-FF_un(:,x1),2)/mean(FF_un(1,x1))*100;


Epm = zeros(nos,number);   Ef = Epm ;
Ef2 = Epm; Ef3 = Epm; Ef5 = Epm; 
Ef4 = Epm; Ef6 = Epm; Ef7 = Epm; Ef8 = Epm;
Epm2 = Epm; Epm3 = Epm; Epm5 = Epm; 
Epm4 = Epm; Epm6 = Epm; Epm7 = Epm; Epm8 = Epm;
Ey = Epm;   Ed = Epm;   Ec = Epm;   Eh = Epm;   Eg = Epm;   Enb = Epm;
Ey2 = Epm;  Ed2 = Epm;  Ec2 = Epm;  Eh2 = Epm;  Eg2 = Epm;  Enb2 = Epm;
Ey3 = Epm;  Ed3 = Epm;  Ec3 = Epm;  Eh3 = Epm;  Eg3 = Epm;  Enb3 = Epm;
Ey4 = Epm;  Ed4 = Epm;  Ec4 = Epm;  Eh4 = Epm;  Eg4 = Epm;  Enb4 = Epm;
Ey5 = Epm;  Ed5 = Epm;  Ec5 = Epm;  Eh5 = Epm;  Eg5 = Epm;  Enb5 = Epm;
Ey6 = Epm;  Ed6 = Epm;  Ec6 = Epm;  Eh6 = Epm;  Eg6 = Epm;  Enb6 = Epm;
Ey7 = Epm;  Ed7 = Epm;  Ec7 = Epm;  Eh7 = Epm;  Eg7 = Epm;  Enb7 = Epm;
Ey8 = Epm;  Ed8 = Epm;  Ec8 = Epm;  Eh8 = Epm;  Eg8 = Epm;  Enb8 = Epm;

tic
%% generate shocks
for num = 1:number

[Ft1,Ft2,~,Ft_un,~] = exostates_shocked(f,shock,rhof,sdf,nos,Sim,tburn1,tburn2);

[Zt,Zt_un,~] = exostates_unshocked(rhoz,sdz,nos,Sim,tburn1,tburn2);

[ZZ1,YY1,CC1,BadB1,DD1,PMPM1,BB1,HH1,GG1,FE1,NB1,NBY1 ] = simu_irf(Ft1,Zt,reentry,nos,Sim,T,tburn1,b,bp,bpr,default,f,q,rr,z,za,para);

[ZZ2,YY2,CC2,BadB2,DD2,PMPM2,BB2,HH2,GG2,FE2,NB2,NBY2 ] = simu_irf(Ft2,Zt,reentry,nos,Sim,T,tburn1,b,bp,bpr,default,f,q,rr,z,za,para);

[ZZ_un,YY_un,CC_un,BadB_un,DD_un,PMPM_un,BB_un,HH_un,GG_un,FE_un,NB_un,NBY_un] = ...
    simu_irf(Ft_un,Zt_un,reentry,nos,Sim,T,tburn1,b,bp,bpr,default,f,q,rr,z,za,para);

%% 1. condition the first period as "in good status"
badstatus = BadB1(1,:)+DD1(1,:)+BadB2(1,:)+DD2(1,:)+BadB_un(1,:)+DD_un(1,:) ;

x1 = badstatus==0;
Ef(:,num) = ff1(FE1,FE2,FE_un,x1);
Eg(:,num) = ff2(GG1,GG2,GG_un,x1);
Epm(:,num) = ff1(PMPM1,PMPM2,PMPM_un,x1);
Ey(:,num) = ff2(YY1,YY2,YY_un,x1);
Ed(:,num) = ff2(BB1,BB2,BB_un,x1);
Ec(:,num) = ff2(CC1,CC2,CC_un,x1);
Eh(:,num) = ff2(HH1,HH2,HH_un,x1);
Enb(:,num) = ff1(NB1,NB2,NB_un,x1);
Enby(:,num) = ff1(NBY1,NBY2,NBY_un,x1);

%% 2. condition the first/second period as "with low productivity"
x2 = badstatus==0 & lambda*ZZ1(1,:)+(1-lambda)*ZZ2(1,:) < z_low;
Ef2(:,num) = ff1(FE1,FE2,FE_un,x2);
Eg2(:,num) = ff2(GG1,GG2,GG_un,x2);
Epm2(:,num) = ff1(PMPM1,PMPM2,PMPM_un,x2);
Ey2(:,num) = ff2(YY1,YY2,YY_un,x2);
Ed2(:,num) = ff2(BB1,BB2,BB_un,x2);
Ec2(:,num) = ff2(CC1,CC2,CC_un,x2);
Eh2(:,num) = ff2(HH1,HH2,HH_un,x2);
Enb2(:,num) = ff1(NB1,NB2,NB_un,x2);
Enby2(:,num) = ff1(NBY1,NBY2,NBY_un,x2);

%% 3. condition the first/second period as "with high indebtedness"
x3 = badstatus==0 & lambda*BB1(1,:)+(1-lambda)*BB2(1,:) > b_bound_high;
Ef3(:,num) = ff1(FE1,FE2,FE_un,x3);
Eg3(:,num) = ff2(GG1,GG2,GG_un,x3);
Epm3(:,num) = ff1(PMPM1,PMPM2,PMPM_un,x3);
Ey3(:,num) = ff2(YY1,YY2,YY_un,x3);
Ed3(:,num) = ff2(BB1,BB2,BB_un,x3);
Ec3(:,num) = ff2(CC1,CC2,CC_un,x3);
Eh3(:,num) = ff2(HH1,HH2,HH_un,x3);
Enb3(:,num) = ff1(NB1,NB2,NB_un,x3);
Enby3(:,num) = ff1(NBY1,NBY2,NBY_un,x3);

%% 4. condition the first/second period as "with low productivity and high indebtedness"
x4 = badstatus==0 & lambda*BB1(1,:)+(1-lambda)*BB2(1,:) > b_bound_high & lambda*ZZ1(1,:)+(1-lambda)*ZZ2(1,:) < z_low  ;
Ef4(:,num) = ff1(FE1,FE2,FE_un,x4);
Eg4(:,num) = ff2(GG1,GG2,GG_un,x4);
Epm4(:,num) = ff1(PMPM1,PMPM2,PMPM_un,x4);
Ey4(:,num) = ff2(YY1,YY2,YY_un,x4);
Ed4(:,num) = ff2(BB1,BB2,BB_un,x4);
Ec4(:,num) = ff2(CC1,CC2,CC_un,x4);
Eh4(:,num) = ff2(HH1,HH2,HH_un,x4);
Enb4(:,num) = ff1(NB1,NB2,NB_un,x4);
Enby4(:,num) = ff1(NBY1,NBY2,NBY_un,x4);

%% 5. condition the first period as "with high productivity"
x5 = badstatus==0 & lambda*ZZ1(1,:)+(1-lambda)*ZZ2(1,:) > z_high;
Ef5(:,num) = ff1(FE1,FE2,FE_un,x5);
Eg5(:,num) = ff2(GG1,GG2,GG_un,x5);
Epm5(:,num) = ff1(PMPM1,PMPM2,PMPM_un,x5);
Ey5(:,num) = ff2(YY1,YY2,YY_un,x5);
Ed5(:,num) = ff2(BB1,BB2,BB_un,x5);
Ec5(:,num) = ff2(CC1,CC2,CC_un,x5);
Eh5(:,num) = ff2(HH1,HH2,HH_un,x5);
Enb5(:,num) = ff1(NB1,NB2,NB_un,x5);
Enby5(:,num) = ff1(NBY1,NBY2,NBY_un,x5);

%% 6. condition the first period as "with high productivity and low indebtedness"
x6 = badstatus==0 & lambda*BB1(1,:)+(1-lambda)*BB2(1,:) < b_bound_low & lambda*ZZ1(1,:)+(1-lambda)*ZZ2(1,:) > z_high ;
Ef6(:,num) = ff1(FE1,FE2,FE_un,x6);
Eg6(:,num) = ff2(GG1,GG2,GG_un,x6);
Epm6(:,num) = ff1(PMPM1,PMPM2,PMPM_un,x6);
Ey6(:,num) = ff2(YY1,YY2,YY_un,x6);
Ed6(:,num) = ff2(BB1,BB2,BB_un,x6);
Ec6(:,num) = ff2(CC1,CC2,CC_un,x6);
Eh6(:,num) = ff2(HH1,HH2,HH_un,x6);
Enb6(:,num) = ff1(NB1,NB2,NB_un,x6);
Enby6(:,num) = ff1(NBY1,NBY2,NBY_un,x6);

%% 7. condition the first period as "high spreads"
x7 = badstatus==0 & lambda*PMPM1(1,:)+(1-lambda)*PMPM2(1,:) > 5.5; % 2010Q1 rs=3.1, 2010Q2 rs = 5.5, 2010Q3 rs=8.3
Ef7(:,num) = ff1(FE1,FE2,FE_un,x7);
Eg7(:,num) = ff2(GG1,GG2,GG_un,x7);
Epm7(:,num) = ff1(PMPM1,PMPM2,PMPM_un,x7);
Ey7(:,num) = ff2(YY1,YY2,YY_un,x7);
Ed7(:,num) = ff2(BB1,BB2,BB_un,x7);
Ec7(:,num) = ff2(CC1,CC2,CC_un,x7);
Eh7(:,num) = ff2(HH1,HH2,HH_un,x7);
Enb7(:,num) = ff1(NB1,NB2,NB_un,x7);
Enby7(:,num) = ff1(NBY1,NBY2,NBY_un,x7);

%% 8. condition the first period as "low spreads"
x8 = badstatus==0 & lambda*PMPM1(1,:)+(1-lambda)*PMPM2(1,:) < 2.4;  % mean(2019Q4,2010Q1), rs=2.4
Ef8(:,num) = ff1(FE1,FE2,FE_un,x8);
Eg8(:,num) = ff2(GG1,GG2,GG_un,x8);
Epm8(:,num) = ff1(PMPM1,PMPM2,PMPM_un,x8);
Ey8(:,num) = ff2(YY1,YY2,YY_un,x8);
Ed8(:,num) = ff2(BB1,BB2,BB_un,x8);
Ec8(:,num) = ff2(CC1,CC2,CC_un,x8);
Eh8(:,num) = ff2(HH1,HH2,HH_un,x8);
Enb8(:,num) = ff1(NB1,NB2,NB_un,x8);
Enby8(:,num) = ff1(NBY1,NBY2,NBY_un,x8);

end

%%
func = @(x) mean(x,2);

E_f = func(Ef);  E_f4 = func(Ef4); E_f6 = func(Ef6); E_f7 = func(Ef7); E_f8 = func(Ef8);
E_f2 = func(Ef2); E_f3 = func(Ef3); E_f5 = func(Ef5); 

E_pm = func(Epm); E_pm4 = func(Epm4); E_pm6 = func(Epm6); E_pm7 = func(Epm7); E_pm8 = func(Epm8);
E_pm2 = func(Epm2); E_pm3 = func(Epm3); E_pm5 = func(Epm5); 
E_d = func(Ed); E_d4 = func(Ed4); E_d6 = func(Ed6); E_d7 = func(Ed7); E_d8 = func(Ed8);
E_d2 = func(Ed2); E_d3 = func(Ed3); E_d5 = func(Ed5); 
E_y = func(Ey); E_y4 = func(Ey4); E_y6 = func(Ey6); E_y7 = func(Ey7); E_y8 = func(Ey8);
E_y2 = func(Ey2); E_y3 = func(Ey3); E_y5 = func(Ey5);
E_c = func(Ec); E_c4 = func(Ec4); E_c6 = func(Ec6); E_c7 = func(Ec7); E_c8 = func(Ec8);
E_c2 = func(Ec2); E_c3 = func(Ec3); E_c5 = func(Ec5);
E_h = func(Eh); E_h4 = func(Eh4); E_h6 = func(Eh6); E_h7 = func(Eh7); E_h8 = func(Eh8);
E_h2 = func(Eh2); E_h3 = func(Eh3); E_h5 = func(Eh5);
E_g = func(Eg); E_g4 = func(Eg4); E_g6 = func(Eg6); E_g7 = func(Eg7); E_g8 = func(Eg8);
E_g2 = func(Eg2); E_g3 = func(Eg3); E_g5 = func(Eg5);

E_nb = func(Enb);    E_nb4 = func(Enb4);  E_nb6 = func(Enb6);  E_nb7 = func(Enb7); E_nb8 = func(Enb8);
E_nb2 = func(Enb2);  E_nb3 = func(Enb3);  E_nb5 = func(Enb5);

E_nby = func(Enby);    E_nby4 = func(Enby4);  E_nby6 = func(Enby6);  E_nby7 = func(Enby7); E_nby8 = func(Enby8);
E_nby2 = func(Enby2);  E_nby3 = func(Enby3);  E_nby5 = func(Enby5);
toc

%% Save results for irfs_illustration.m

save irf_Frise.mat -regexp E_f.* E_c.* E_pm.* E_d.* E_h.* E_y.* E_g.* E_nb.* E_nby.*

