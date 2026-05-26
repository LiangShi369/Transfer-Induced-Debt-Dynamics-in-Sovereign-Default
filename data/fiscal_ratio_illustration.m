clear

% revisions of trend growth and cyclical growth estimates

g_gre = readmatrix('GIIPS fiscal.xlsx','Sheet','greece','Range','c39:c43') ;
g_spa = readmatrix('GIIPS fiscal.xlsx','Sheet','spain','Range','c39:c43') ;
g_ita = readmatrix('GIIPS fiscal.xlsx','Sheet','italy','Range','c39:c43') ;
g_pot = readmatrix('GIIPS fiscal.xlsx','Sheet','portugal','Range','c39:c43') ;
g_ire = readmatrix('GIIPS fiscal.xlsx','Sheet','ireland','Range','c39:c43') ;

a1 = [g_gre, g_pot, g_ire] ;
a2 = [g_spa, g_ita] ;
mean_g1 = mean(a1,2) ;
mean_g2 = mean(a2,2) ;

mean_g = mean([a1 a2] , 2);
%%
f_gre = readmatrix('GIIPS fiscal.xlsx','Sheet','greece','Range','g39:g43') ;
f_spa = readmatrix('GIIPS fiscal.xlsx','Sheet','spain','Range','g39:g43') ;
f_ita = readmatrix('GIIPS fiscal.xlsx','Sheet','italy','Range','g39:g43') ;
f_pot = readmatrix('GIIPS fiscal.xlsx','Sheet','portugal','Range','g39:g43') ;
f_ire = readmatrix('GIIPS fiscal.xlsx','Sheet','ireland','Range','g39:g43') ;

a1 = [f_gre, f_pot, f_ire] ;
a2 = [f_spa, f_ita] ;
mean_f1 = mean(a1,2) ;
mean_f2 = mean(a2,2) ;

mean_f = mean([a1 a2] , 2);
%%
tax_gre = readmatrix('GIIPS fiscal.xlsx','Sheet','greece','Range','k39:k43') ;
tax_spa = readmatrix('GIIPS fiscal.xlsx','Sheet','spain','Range','k39:k43') ;
tax_ita = readmatrix('GIIPS fiscal.xlsx','Sheet','italy','Range','k39:k43') ;
tax_pot = readmatrix('GIIPS fiscal.xlsx','Sheet','portugal','Range','k39:k43') ;
tax_ire = readmatrix('GIIPS fiscal.xlsx','Sheet','ireland','Range','k39:k43') ;

a1 = [tax_gre, tax_pot, tax_ire] ;
a2 = [tax_spa, tax_ita] ;
mean_tax1 = mean(a1,2) ;
mean_tax2 = mean(a2,2) ;

mean_tax = mean([a1 a2] , 2);
%%
width = 0.6 ;


subplot(2,3,4)
plot(f_gre,Marker="square",LineStyle="-.",LineWidth=width)
hold on
plot(f_spa,Marker="o",LineStyle="-.",LineWidth=width)
plot(f_ita,LineStyle="-.",LineWidth=width)
plot(f_pot,Marker="x",LineStyle="-.",LineWidth=width)
plot(f_ire,Marker="*",LineStyle="-.",LineWidth=width)
plot(mean_f,LineWidth=2.5,Color='b')
hold off
ylim([-1.5 6])
xticks(1:1:5)
xticklabels({'-4','-3','-2','-1','0'})
legend({'Greece','Spain','Italy','Portugal','Ireland','Mean'},Location="southeast")
title('Transfer spending %GDP')
xlabel('Years to spreads peak')
ylabel('% point dev')
grid on

subplot(2,3,5)
plot(g_gre,Marker="square",LineStyle="-.",LineWidth=width)
hold on
plot(g_spa,Marker="o",LineStyle="-.",LineWidth=width)
plot(g_ita,LineStyle="-.",LineWidth=width)
plot(g_pot,Marker="x",LineStyle="-.",LineWidth=width)
plot(g_ire,Marker="*",LineStyle="-.",LineWidth=width)
plot(mean_g,LineWidth=2.5,Color='b')
hold off
ylim([-1 4])
xticks(1:1:5)
xticklabels({'-4','-3','-2','-1','0'})
title('Govt consumption %GDP')
xlabel('Years to spreads peak')
ylabel('% point dev')
grid on


subplot(2,3,6)
plot(tax_gre,Marker="square",LineStyle="-.",LineWidth=width)
hold on
plot(tax_spa,Marker="o",LineStyle="-.",LineWidth=width)
plot(tax_ita,LineStyle="-.",LineWidth=width)
plot(tax_pot,Marker="x",LineStyle="-.",LineWidth=width)
plot(tax_ire,Marker="*",LineStyle="-.",LineWidth=width)
plot(mean_tax,LineWidth=2.5,Color='b')
hold off
ylim([-7 4])
xticks(1:1:5)
xticklabels({'-4','-3','-2','-1','0'})
title('Tax revenue %GDP')
xlabel('Years to spreads peak')
ylabel('% point dev')
grid on


