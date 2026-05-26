clear

load fiscal_zf2.mat 
phi0 = para.phi0 ;    phi1 = para.phi1;   alfa = para.alfa;   betta = para.betta; 
psi0 = para.psi0;     psi1 = para.psi1;   sigg_bpr = para.sigg_bpr;    sigg_bp=para.sigg_bp;
sigg_defp=para.sigg_defp;  mu = para.mu;   chi = para.chi ;  rbase = para.rbase ;
coup = para.coup ;    eta = para.eta ;    tauc = para.tauc ;   tauh = para.tauh ;
v = para.v ;

% make q 3 dimentional
q3 = zeros(nz,nf,nb) ; 
def3 = zeros(nz,nf,nb) ;
bp3 = zeros(nz,nf,nb) ; 

for iz = 1:nz
    for ife = 1:nf
        is = (ife - 1) * nz + iz ; 
        for ib = 1:nb
            q3(iz,ife,ib) = q(is,ib) ; 
            def3(iz,ife,ib) = default(is,ib) ;
            bp3(iz,ife,ib) = bp(is,ib) ;
        end
    end
end

% fill default zone price with the nearest price
q3_fill = q3 ;     % aa= squeeze(q3_fill(:,1,:))  ;
def_threshold = zeros(nz,nf,nb) ;   %  aa= squeeze(def_threshold(:,31,:))  ;

for iz = 1:nz
for ife = 1:nf
    for ib = 1:nb
        [~,indix] = min(def3(:,ife,ib)) ; 
        def_threshold(iz,ife,ib) = indix -1 ;  % find the default set
        if indix > 1
            avg = q3(indix,ife,ib)*2/3 + q3(indix-1,ife,ib)/3 ;
            q3_fill(1:indix-1,ife,ib) = avg ;  % fill default zone price with the nearest price
        end
    end

end
end

%% draw default set

defset = zeros(nz,nb) ;
for ife = 1:nf
    for iz = 1:nz
        for ib = 1:nb
            defset(iz,ib) = def3(iz,ife,ib) ;
        end
    end
    number = sprintf('f%d', ife);
    def_zb.(number) = defset;
end

defline = zeros(nb,1) ;
for ife = 1:nf
    number = sprintf('f%d', ife);
    defset = def_zb.(number);
    for ib = 1:nb
        [minv, minind] = min(defset(:,ib)) ;
        if minv == 0
            defline(ib) = z(minind) ;
        elseif minv == 1
            defline(ib) = z(nz) ;
        end
    end
    defline_zb.(number) = defline;
end

%% Default set

def_line1 = defline_zb.f8 ;
def_line2 = defline_zb.f18 ;

figure
plot(b,def_line1, Color='blue')
hold on
plot(b,def_line2, Color='red')
ylim([z(1) z(21)])
xlim([b(152) b(end)])
xlabel('$b/\bar{y}$','FontSize', 16,'Interpreter','latex')
ylabel('Productivity','FontSize', 12)

x_fill1 = [b; flipud(b)];  
y_fill1 = [def_line1; z(1)*ones(size(def_line1))];
fill(x_fill1, y_fill1, 'blue', 'FaceAlpha', 0.15, 'EdgeColor', 'none')  

x_fill2 = [b; flipud(b)];  
y_fill2 = [def_line2; flipud(def_line1)];  
fill(x_fill2, y_fill2, 'red', 'FaceAlpha', 0.15, 'EdgeColor', 'none')  

x_text1 = b(215); 
y_text1 = z(4);
text(x_text1, y_text1, 'Default threshold, low transfers', 'Color', 'blue', 'FontSize', 13,'Interpreter','latex')
annotation('textarrow', [0.77 0.72], [0.26 0.43], 'String', '', 'Color', 'blue')

x_text1 = b(180); 
y_text1 = z(15);
text(x_text1, y_text1, 'Default threshold, high transfers', 'Color', 'red', 'FontSize', 14,'Interpreter','latex')
annotation('textarrow', [0.56 0.65], [0.65 0.52], 'String', '', 'Color', 'red')

hold off
grid on

%% Policies for b, rs, nb, high debts outstanding

ib = 180 ;
ife_low = 7 ; 
ife_high = 19 ;

q_lowf = nan(nz,1) ;    q_highf = nan(nz,1) ;
def_lowf = nan(nz,1) ;  def_highf = nan(nz,1) ; 
bp_lowf = nan(nz,1) ;   bp_highf = nan(nz,1) ; 
nb_lowf = nan(nz,1) ;   nb_highf = nan(nz,1) ; 
g_lowf_highb = nan(nz,1) ;    g_highf_highb = nan(nz,1) ; 

for iz = 1:nz

    is1 = (ife_low-1)*nz + iz ;
    is2 = (ife_high-1)*nz + iz ;
    pol1 = bp(is1,ib) ;
    pol2 = bp(is2,ib) ;

    if default(is1,pol1) == 0
    
    def_lowf(iz) = default(is1,pol1) ;  % choose to default ?
    q_lowf(iz) = q(is1,pol1) ;
    bp_lowf(iz) = b(pol1) ; 
    
    h = ( -(psi0 + f(ife_low))/(1-tauh)./exp(z(iz)) + sqrt(((psi0 + f(ife_low))/(1-tauh)./exp(z(iz))).^2 + 4/v) ) / 2 ; 
    c = ( (1-tauh)*exp(z(iz)).*h + psi0 + f(ife_low) ) / (1+tauc) ;
    y = exp(z(iz)) * h ;
    transfer = psi0 + f(ife_low) ;
    nb_lowf(iz) = ( q(is1,pol1)*(b(pol1)-(1-eta)*b(ib)) - (eta + (1-eta)*coup)*b(ib) ) ;
    g_lowf_highb(iz) = ( min(y - c, tauc*c + tauh*y - transfer) + nb_lowf(iz) ) ;

    end

    if default(is2,pol2) == 0

    def_highf(iz) = default(is2,pol2) ;  % choose to default ?
    q_highf(iz) = q(is2,pol2) ;
    bp_highf(iz) = b(pol2) ; 

    h = ( -(psi0 + f(ife_high))/(1-tauh)./exp(z(iz)) + sqrt(((psi0 + f(ife_high))/(1-tauh)./exp(z(iz))).^2 + 4/v) ) / 2 ; 
    c = ( (1-tauh)*exp(z(iz)).*h + psi0 + f(ife_high) ) / (1+tauc) ;
    y = exp(z(iz)) * h ;
    transfer = psi0 + f(ife_high) ;
    nb_highf(iz) = ( q(is2,pol2)*(b(pol2)-(1-eta)*b(ib)) - (eta + (1-eta)*coup)*b(ib) ) ;
    g_highf_highb(iz) = ( min(y - c, tauc*c + tauh*y - transfer) + nb_lowf(iz) ) ;

    end

end

rs_lowf = (((eta+(1-eta)*coup)./q_lowf +1-eta ).^4-1)*100 - ((1+rbase)^4-1)*100;
rs_highf = (((eta+(1-eta)*coup)./q_highf +1-eta ).^4-1)*100 - ((1+rbase)^4-1)*100;


lwidth = 1.85 ;

figure

subplot(2,4,1)
plot(z, rs_highf , LineWidth=lwidth)
hold on
plot(z, rs_lowf , LineWidth=lwidth, LineStyle="--")
hold off
title('(a.1) $rs_{t}$ at high b','interpreter','latex', fontsize=13)
xlabel('z','interpreter','latex', fontsize=14)
ylabel('bps')
xlim([z(1) z(end)])
ylim([0 15])
grid on

subplot(2,4,2)
plot(z, bp_highf*100 , LineWidth=lwidth)
hold on
plot(z, bp_lowf*100 , LineWidth=lwidth, LineStyle="--")
hold off
legend('High $\varepsilon^{f}$','Low $\varepsilon^{f}$','interpreter','latex', fontsize=12, location='southwest')
title('(b.1) $b_{t+1}/\bar{y}$ at high b','interpreter','latex', fontsize=13)
xlabel('z','interpreter','latex', fontsize=12)
ylabel('% points')
xlim([z(1) z(end)])
ylim([74 78.25])
grid on

subplot(2,4,3)
plot(z, nb_highf*100 , LineWidth=lwidth)
hold on
plot(z, nb_lowf*100 , LineWidth=lwidth, LineStyle="--")
hold off
title('(c.1) $NB_t/\bar{y}$ at high b','interpreter','latex', fontsize=13)
xlabel('z','interpreter','latex', fontsize=14)
ylabel('% points')
xlim([z(1) z(end)])
ylim([-4.7 -1.5])
grid on

subplot(2,4,4)
plot(z, g_highf_highb*100 , LineWidth=lwidth)
hold on
plot(z, g_lowf_highb*100 , LineWidth=lwidth, LineStyle="--")
hold off
title('(d.1) $g_{t}/\bar{y}$ at high b','interpreter','latex', fontsize=13)
xlabel('z','interpreter','latex', fontsize=14)
ylabel('% points')
xlim([z(1) z(end)])
ylim([19 40])
grid on


%% Policies for b, rs, nb, low debts outstanding
ib = 50 ;
ife_low = 7 ; 
ife_high = 19 ;

% debt price when the not choosing default next period
q_lowf = nan(nz,1) ;    q_highf = nan(nz,1) ;
def_lowf = nan(nz,1) ;  def_highf = nan(nz,1) ; 
bp_lowf = nan(nz,1) ;   bp_highf = nan(nz,1) ; 
nb_lowf = nan(nz,1) ;   nb_highf = nan(nz,1) ; 
g_lowf_lowb = nan(nz,1) ;    g_highf_lowb = nan(nz,1) ; 

for iz = 1:nz

    is1 = (ife_low-1)*nz + iz ;
    pol1 = bp(is1,ib) ;

    is2 = (ife_high-1)*nz + iz ;
    pol2 = bp(is2,ib) ;

    if default(is1,pol1) == 0  % choose not to default 

    def_lowf(iz) = default(is1,pol1) ; 
    q_lowf(iz) = q(is1,pol1) ;
    bp_lowf(iz) = b(pol1) ; 

    h = ( -(psi0 + f(ife_low))/(1-tauh)./exp(z(iz)) + sqrt(((psi0 + f(ife_low))/(1-tauh)./exp(z(iz))).^2 + 4/v) ) / 2 ; 
    c = ( (1-tauh)*exp(z(iz)).*h + psi0 + f(ife_low) ) / (1+tauc) ;
    y = exp(z(iz)) * h ;
    transfer = psi0 + f(ife_low) ;
    nb_lowf(iz) = ( q(is1,pol1)*(b(pol1)-(1-eta)*b(ib)) - (eta + (1-eta)*coup)*b(ib) )  ;
    g_lowf_lowb(iz) = ( min(y - c, tauc*c + tauh*y - transfer) + nb_lowf(iz) ) ;

    end

    if default(is2,pol2) == 0  % choose not to default 

    def_highf(iz) = default(is2,pol2) ; 
    q_highf(iz) = q(is2,pol2) ;
    bp_highf(iz) = b(pol2) ; 

    h = ( -(psi0 + f(ife_high))/(1-tauh)./exp(z(iz)) + sqrt(((psi0 + f(ife_high))/(1-tauh)./exp(z(iz))).^2 + 4/v) ) / 2 ; 
    c = ( (1-tauh)*exp(z(iz)).*h + psi0 + f(ife_high) ) / (1+tauc) ;
    y = exp(z(iz)) * h ;
    transfer = psi0 + f(ife_high) ;
    nb_highf(iz) = ( q(is2,pol2)*(b(pol2)-(1-eta)*b(ib)) - (eta + (1-eta)*coup)*b(ib) ) ;
    g_highf_lowb(iz) = ( min(y - c, tauc*c + tauh*y - transfer) + nb_lowf(iz) ) ;

    end
end

rs_lowf = (((eta+(1-eta)*coup)./q_lowf +1-eta ).^4-1)*100 - ((1+rbase)^4-1)*100;
rs_highf = (((eta+(1-eta)*coup)./q_highf +1-eta ).^4-1)*100 - ((1+rbase)^4-1)*100;


subplot(2,4,5)
plot(z, rs_highf , LineWidth=lwidth)
hold on
plot(z, rs_lowf , LineWidth=lwidth, LineStyle="--")
hold off
legend('High $\varepsilon^{f}$','Low $\varepsilon^{f}$','interpreter','latex', fontsize=12)
title('(a.2) $rs_{t}$ at low b','interpreter','latex', fontsize=13)
xlabel('z','interpreter','latex', fontsize=14)
ylabel('% points')
xlim([z(1) z(end)])
ylim([0 10])
grid on

subplot(2,4,6)
plot(z, bp_highf*100 , LineWidth=lwidth)
hold on
plot(z, bp_lowf*100, LineWidth=lwidth, LineStyle="--")
hold off
title('(b.2) $b_{t+1}/\bar{y}$ at low b','interpreter','latex', fontsize=13)
xlabel('z','interpreter','latex', fontsize=14)
ylabel('% points')
xlim([z(1) z(end)])
ylim([44 50])
grid on

subplot(2,4,7)
plot(z, nb_highf*100, LineWidth=lwidth)
hold on
plot(z, nb_lowf*100, LineWidth=lwidth, LineStyle="--")
hold off
title('(c.2) $NB_t/\bar{y}$ at low b','interpreter','latex', fontsize=13)
xlabel('z','interpreter','latex', fontsize=14)
ylabel('% points')
xlim([z(1) z(end)])
ylim([-3.5 2.5])
grid on

subplot(2,4,8)
plot(z, g_highf_lowb*100 , LineWidth=lwidth)
hold on
plot(z, g_lowf_lowb*100 , LineWidth=lwidth, LineStyle="--")
hold off
title('(d.2) $g_t/\bar{y}$ at low b','interpreter','latex', fontsize=13)
xlabel('z','interpreter','latex', fontsize=14)
ylabel('% points')
xlim([z(1) z(end)])
ylim([18 42])
grid on

