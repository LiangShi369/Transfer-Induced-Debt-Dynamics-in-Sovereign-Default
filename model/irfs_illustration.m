clear

load irf_Frise.mat

lwidth = 2; 

%%
figure

subplot(3,2,1)
plot(E_pm*100, LineWidth=lwidth, LineStyle="-")
hold on
plot(E_pm4*100, LineWidth=lwidth, LineStyle="--")
plot(E_pm6*100, LineWidth=lwidth, LineStyle=":")
hold off
title('$rs_{t}$',Interpreter='latex', FontSize=12)
legend('Unconditional', 'High stress', 'Low stress', FontSize=8)
ylabel('bps change')
ylim([0 125])
xlim([0 55])
grid on


subplot(3,2,2)
plot(E_d, LineWidth=lwidth)
hold on
plot(E_d4, LineWidth=lwidth, LineStyle="--")
plot(E_d6, LineWidth=lwidth, LineStyle=":")
hold off
title('$b_{t}/\bar{y}$',Interpreter='latex', FontSize=12)
ylabel('% change')
ylim([0 1.6])
xlim([0 55])
grid on


subplot(3,2,3)
plot(E_y, LineWidth=lwidth)
hold on
plot(E_y4, LineWidth=lwidth, LineStyle="--")
plot(E_y6, LineWidth=lwidth, LineStyle=":")
hold off
title('$y_{t}$',Interpreter='latex', FontSize=12)
ylabel('% change')
ylim([-0.65 0])
xlim([0 55])
grid on


subplot(3,2,4)
plot(E_c, LineWidth=lwidth)
hold on
plot(E_c4, LineWidth=lwidth, LineStyle="--")
plot(E_c6, LineWidth=lwidth, LineStyle=":")
hold off
title('$c_{t}$',Interpreter='latex', FontSize=12)
ylabel('% change')
ylim([0 0.62])
xlim([0 55])
grid on


subplot(3,2,5)
plot(E_h, LineWidth=lwidth)
hold on
plot(E_h4, LineWidth=lwidth, LineStyle="--")
plot(E_h6, LineWidth=lwidth, LineStyle=":")
hold off
title('$h_{t}$',Interpreter='latex', FontSize=12)
ylabel('% change')
ylim([-0.65 0])
xlim([0 55])
grid on


subplot(3,2,6)
plot(E_g, LineWidth=lwidth)
hold on
plot(E_g4, LineWidth=lwidth, LineStyle="--")
plot(E_g6, LineWidth=lwidth, LineStyle=":")
hold off
title('$g_{t}$',Interpreter='latex', FontSize=12)
ylabel('% change')
ylim([-3.5 0])
xlim([0 55])
grid on


%%


figure

subplot(3,2,1)
plot(E_pm*100, LineWidth=lwidth, LineStyle="-")
hold on
plot(E_pm7*100, LineWidth=lwidth, LineStyle="--")
plot(E_pm8*100, LineWidth=lwidth, LineStyle=":")
hold off
title('(a) $rs_{t}$',Interpreter='latex', FontSize=14)
legend('Unconditional', 'High stress', 'Low stress', FontSize=10)
ylabel('bps change')
ylim([0 200])
xlim([0 50])
grid on


subplot(3,2,2)
plot(E_d, LineWidth=lwidth)
hold on
plot(E_d7, LineWidth=lwidth, LineStyle="--")
plot(E_d8, LineWidth=lwidth, LineStyle=":")
hold off
title('(b) $b_{t}/\bar{y}$',Interpreter='latex', FontSize=14)
ylabel('% change')
ylim([0 2.4])
xlim([0 50])
grid on


subplot(3,2,3)
plot(E_y, LineWidth=lwidth)
hold on
plot(E_y7, LineWidth=lwidth, LineStyle="--")
plot(E_y8, LineWidth=lwidth, LineStyle=":")
hold off
title('(c) $y_{t}$',Interpreter='latex', FontSize=14)
ylabel('% change')
ylim([-0.75 0])
xlim([0 50])
grid on


subplot(3,2,4)
plot(E_c, LineWidth=lwidth)
hold on
plot(E_c7, LineWidth=lwidth, LineStyle="--")
plot(E_c8, LineWidth=lwidth, LineStyle=":")
hold off
title('(d) $c_{t}$',Interpreter='latex', FontSize=14)
ylabel('% change')
ylim([0 0.65])
xlim([0 50])
grid on


subplot(3,2,5)
plot(E_h, LineWidth=lwidth)
hold on
plot(E_h7, LineWidth=lwidth, LineStyle="--")
plot(E_h8, LineWidth=lwidth, LineStyle=":")
hold off
title('(e) $h_{t}$',Interpreter='latex', FontSize=14)
ylabel('% change')
ylim([-0.66 0])
xlim([0 50])
grid on


subplot(3,2,6)
plot(E_g, LineWidth=lwidth)
hold on
plot(E_g7, LineWidth=lwidth, LineStyle="--")
plot(E_g8, LineWidth=lwidth, LineStyle=":")
hold off
title('(f) $g_{t}$',Interpreter='latex', FontSize=14)
ylabel('% change')
ylim([-3.75 0])
xlim([0 50])
grid on

%%

figure

subplot(1,2,1)
plot(E_pm*100, LineWidth=lwidth, LineStyle="-")
hold on
plot(E_pm4*100, LineWidth=lwidth, LineStyle="--")
plot(E_pm6*100, LineWidth=lwidth, LineStyle=":")
hold off
title('(a) $rs_{t}$',Interpreter='latex', FontSize=15)
legend('Unconditional','High stress', 'Low stress', FontSize=11)
ylabel('bps change')
ylim([0 125])
xlim([0 50])
grid on


subplot(1,2,2)
plot(E_d, LineWidth=lwidth)
hold on
plot(E_d4, LineWidth=lwidth, LineStyle="--")
plot(E_d6, LineWidth=lwidth, LineStyle=":")
hold off
title('(b) $b_{t}/\bar{y}$',Interpreter='latex', FontSize=15)
ylabel('% change')
ylim([0 1.6])
xlim([0 50])
grid on


