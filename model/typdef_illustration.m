clear

load typdef.mat 

tb = 16; %periods before default
ta = 16; %periods after default
t = (-tb:1:ta);

figure

subplot(4,2,1)
plot(t,log(ytilde_mean) - log(ytilde_mean(1)),'-','linewidth',2) 
xline(0, '--','linewidth',1.5)
set(gca,'xtick', -tb:2:ta)
title('(a) $y_{t}$',Interpreter='latex', FontSize=15)
ylim([-0.15 0.025])
xlim([-tb ta])
ylabel('log dev')
grid on


subplot(4,2,2)
plot(t,log(c_mean) - log(c_mean(1)),'-','linewidth',2) 
xline(0, '--','linewidth',1.5)
set(gca,'xtick', -tb:2:ta)
title('(b) $c_{t}$',Interpreter='latex', FontSize=15)
ylim([-0.105 0.02])
xlim([-tb ta])
ylabel('log dev')
grid on


subplot(4,2,3)
plot(t,log(zt_mean) - log(zt_mean(1)),'-','linewidth',2) 
xline(0, '--','linewidth',1.5)
set(gca,'xtick', -tb:2:ta)
title('(c) $z_{t}$',Interpreter='latex', FontSize=15)
ylim([-0.12 0.02])
xlim([-tb ta])
ylabel('log dev')
grid on


subplot(4,2,4)
plot(t,ff_mean - ff_mean(1),'-','linewidth',2) 
xline(0, '--','linewidth',1.5)
set(gca,'xtick', -tb:2:ta)
title('(d) $f_{t}/y_t$',Interpreter='latex', FontSize=15)
ylim([-0.4 3.5])
xlim([-tb ta])
ylabel('% point dev')
grid on


subplot(4,2,5)
plot(t,dy_mean - dy_mean(1),'-','linewidth',2) 
xline(0, '--','linewidth',1.5)
set(gca,'xtick', -tb:2:ta)
title('(e) $b_{t}/y_t$',Interpreter='latex', FontSize=15)
ylim([-5 47])
xlim([-tb ta])
ylabel('% point dev')
grid on


subplot(4,2,6)
plot(t,pm_mean - pm_mean(1),'-','linewidth',2) 
xline(0, '--','linewidth',1.5)
set(gca,'xtick', -tb:2:ta)
title('(f) $rs_t$',Interpreter='latex', FontSize=15)
ylim([-5 37])
xlim([-tb ta])
ylabel('% point dev')
grid on


subplot(4,2,7)
plot(t,tby_mean*100 - tby_mean(1)*100,'-','linewidth',2) 
xline(0, '--','linewidth',1.5)
set(gca,'xtick', -tb:2:ta)
title('(g) $tby_t$',Interpreter='latex', FontSize=15)
ylim([-5 15])
xlim([-tb ta])
ylabel('% point dev')
grid on


subplot(4,2,8)
plot(t,log(gt_mean/100) - log(gt_mean(1)/100),'-','linewidth',2) 
xline(0, '--','linewidth',1.5)
set(gca,'xtick', -tb:2:ta)
title('(h) $g_t$',Interpreter='latex', FontSize=15)
ylim([-0.23 0.23])
xlim([-tb ta])
ylabel('log dev')
grid on


