clear

t = (-16:0)';

load typdef.mat
load fiscal_zf2.mat para f

load analyze_event_ife9.mat 
PM_ife9 = PM; def_ife9 = def_vec ;

load analyze_event_ife10.mat 
PM_ife10 = PM; def_ife10 = def_vec ;

load analyze_event_ife13.mat 
PM_ife13 = PM; def_ife13 = def_vec ;

f(13) + para.psi0 
f(10) + para.psi0
f(9) + para.psi0

%%
% the fe shocks prior to default is
fe_shocks = [ 0.3770, 0.4151, 0.4525, 0.4830, 0.5126, 0.5528, 0.5900, 0.6533, 0.7087, 0.7746, ...
    0.8383, 0.9134, 0.9912, 1.0872, 1.2135, 1.4061, 1.3412 ] ;
% the actual rise in f is 
f_typical = fe_shocks/100 + para.psi0 ;


f_13 = ones(11,1)*(f(13)+ para.psi0)*100 ;
f_13(1) = f_typical(7)*100 ;

f_10 = ones(11,1)*(f(10)+ para.psi0)*100 ;
f_10(1) = f_typical(7)*100 ;

f_9 = ones(11,1)*(f(9)+ para.psi0)*100 ;
f_9(1) = f_typical(7)*100 ;
%%
wid = 2 ;

figure

subplot(1,2,1)
plot(t(7:end),f_typical(7:end)'*100,LineWidth=wid)
hold on
plot(t(7:end),f_13,LineWidth=wid,LineStyle="--",Marker="o")
plot(t(7:end),f_10,LineWidth=wid,LineStyle="--",Marker="x")
plot(t(7:end),f_9,LineWidth=wid,LineStyle="--",Marker="diamond")
hold off
ylim([9.5 16.5])
grid on
xticks([-9 -6 -3 0])
xticklabels({'2010Q1','2010Q4','2011Q3','2012Q2'})
title('(a) $f_t/\bar{y}$', Interpreter='latex',fontsize=15)
ylabel('% points')


subplot(1,2,2)
plot(t(7:end),pm_mean(7:17)',LineWidth=wid)
hold on
plot(t(7:end),PM_ife13(7:17),LineWidth=wid,LineStyle="--",Marker="o")
plot(t(7:end),PM_ife10(7:17),LineWidth=wid,LineStyle="--",Marker="x")
plot(t(7:end),PM_ife9(7:17),LineWidth=wid,LineStyle="--",Marker="diamond")
hold off
lg = legend('Benchmark','$f_t/\bar{y}$ = 14.0\%', '$f_t/\bar{y}$ = 11.8\%', '$f_t/\bar{y}$ = 11.0\%') ;
set(lg, 'Interpreter','latex')
set(lg,"Location","northwest")
set(lg,fontsize=13)
ylim([-3 38])
grid on
xticks([-9 -6 -3 0])
xticklabels({'2010Q1','2010Q4','2011Q3','2012Q2'})
title('(b) $rs_t$', Interpreter='latex',fontsize=15)
ylabel('% points')

