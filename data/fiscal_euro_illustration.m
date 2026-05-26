clear

% revisions of trend growth and cyclical growth estimates

g_gre = readmatrix('GIIPS fiscal.xlsx','Sheet','greece','Range','c32:c36') ;
g_spa = readmatrix('GIIPS fiscal.xlsx','Sheet','spain','Range','c32:c36') ;
g_ita = readmatrix('GIIPS fiscal.xlsx','Sheet','italy','Range','c32:c36') ;
g_pot = readmatrix('GIIPS fiscal.xlsx','Sheet','portugal','Range','c32:c36') ;
g_ire = readmatrix('GIIPS fiscal.xlsx','Sheet','ireland','Range','c32:c36') ;

a1 = [g_gre, g_pot, g_ire] ;
a2 = [g_spa, g_ita] ;
mean_g1 = mean(a1,2) ;
mean_g2 = mean(a2,2) ;

mean_g = mean([a1 a2] , 2);
%%
f_gre = readmatrix('GIIPS fiscal.xlsx','Sheet','greece','Range','g32:g36') ;
f_spa = readmatrix('GIIPS fiscal.xlsx','Sheet','spain','Range','g32:g36') ;
f_ita = readmatrix('GIIPS fiscal.xlsx','Sheet','italy','Range','g32:g36') ;
f_pot = readmatrix('GIIPS fiscal.xlsx','Sheet','portugal','Range','g32:g36') ;
f_ire = readmatrix('GIIPS fiscal.xlsx','Sheet','ireland','Range','g32:g36') ;

a1 = [f_gre, f_pot, f_ire] ;
a2 = [f_spa, f_ita] ;
mean_f1 = mean(a1,2) ;
mean_f2 = mean(a2,2) ;

mean_f = mean([a1 a2] , 2);
%%
tax_gre = readmatrix('GIIPS fiscal.xlsx','Sheet','greece','Range','k32:k36') ;
tax_spa = readmatrix('GIIPS fiscal.xlsx','Sheet','spain','Range','k32:k36') ;
tax_ita = readmatrix('GIIPS fiscal.xlsx','Sheet','italy','Range','k32:k36') ;
tax_pot = readmatrix('GIIPS fiscal.xlsx','Sheet','portugal','Range','k32:k36') ;
tax_ire = readmatrix('GIIPS fiscal.xlsx','Sheet','ireland','Range','k32:k36') ;

a1 = [tax_gre, tax_pot, tax_ire] ;
a2 = [tax_spa, tax_ita] ;
mean_tax1 = mean(a1,2) ;
mean_tax2 = mean(a2,2) ;

mean_tax = mean([a1 a2] , 2);
%%
width = 0.6 ;


subplot(2,3,1)
plot(f_gre*100-100,Marker="square",LineStyle="-.",LineWidth=width)
hold on
plot(f_spa*100-100,Marker="o",LineStyle="-.",LineWidth=width)
plot(f_ita*100-100,LineStyle="-.",LineWidth=width)
plot(f_pot*100-100,Marker="x",LineStyle="-.",LineWidth=width)
plot(f_ire*100-100,Marker="*",LineStyle="-.",LineWidth=width)
plot(mean_f*100-100,LineWidth=2.5,Color='b')
% yline(100, LineStyle="--",LineWidth=1.5,Color='k')
hold off
ylim([-15 40])
xticks(1:1:5)
xticklabels({'-4','-3','-2','-1','0'})
title('Transfer spending euros')
xlabel('Years to spreads peak')
ylabel('% dev')
grid on

subplot(2,3,2)
plot(g_gre*100-100,Marker="square",LineStyle="-.",LineWidth=width)
hold on
plot(g_spa*100-100,Marker="o",LineStyle="-.",LineWidth=width)
plot(g_ita*100-100,LineStyle="-.",LineWidth=width)
plot(g_pot*100-100,Marker="x",LineStyle="-.",LineWidth=width)
plot(g_ire*100-100,Marker="*",LineStyle="-.",LineWidth=width)
plot(mean_g*100-100,LineWidth=2.5,Color='b')
% yline(100, LineStyle="--",LineWidth=1.5,Color='k')
hold off
ylim([-20 20])
xticks(1:1:5)
xticklabels({'-4','-3','-2','-1','0'})
legend({'Greece','Spain','Italy','Portugal','Ireland','Mean'},Location="southwest")
title('Govt consumption euros')
xlabel('Years to spreads peak')
ylabel('% dev')
grid on


subplot(2,3,3)
plot(tax_gre*100-100,Marker="square",LineStyle="-.",LineWidth=width)
hold on
plot(tax_spa*100-100,Marker="o",LineStyle="-.",LineWidth=width)
plot(tax_ita*100-100,LineStyle="-.",LineWidth=width)
plot(tax_pot*100-100,Marker="x",LineStyle="-.",LineWidth=width)
plot(tax_ire*100-100,Marker="*",LineStyle="-.",LineWidth=width)
plot(mean_tax*100-100,LineWidth=2.5,Color='b')
% yline(100, LineStyle="--",LineWidth=1.5,Color='k')
hold off
ylim([-40 15])
xticks(1:1:5)
xticklabels({'-4','-3','-2','-1','0'})
title('Tax revenue euros')
xlabel('Years to spreads peak')
ylabel('% dev')
grid on


