%% For a family of springs that we considered, these are the trends.
clear all; close all; clc;
load_path
di_p = [];
Nt_p = [];
delta_p = [];
nu_p = [];
Lf_p = [];
dw_p = [];
for j = 1:1000
%% Load the spring
spring_nom = nominal_spring();
if j < 333
spring_nom.d_i = .046;
spring_nom.d_w = .004;
spring_nom.L_free = .275;
spring_nom.N_t = 9.5;
elseif j < 666
spring_nom.d_i = .120;
spring_nom.d_w = .012;
spring_nom.L_free = .32;
spring_nom.N_t = 3.5;
end
%% Perturb the nominal spring
spring_nom.d_i = spring_nom.d_i*(1 + randn/20);
spring_nom.d_w = spring_nom.d_w*(1 + randn/20);
spring_nom.N_t = spring_nom.N_t*(1 + randn/20);
spring_nom.L_free = spring_nom.L_free*(1 + randn/20);
%% Find the nominal twist
spring = Convert_Build_Params(spring_nom);
delta_nom = spring.delta_max*.5;
delta_nom = delta_nom*(1 + randn/20);
theta_nom = compute_theta(spring,delta_nom);
%% Set up things for the legend
l_int = 1;
%% Vary di
spring = Convert_Build_Params(spring_nom);
di_nom = spring.d_i;
di_vary = linspace(.75*di_nom,1.25*di_nom,101);
thetas = zeros(size(di_vary));
for k = 1:length(di_vary)
    spring = spring_nom;
    spring.d_i = di_vary(k);
    spring = Convert_Build_Params(spring);
    thetas(k) = compute_theta(spring,delta_nom);
end
di_p = [di_p; 100*(thetas-theta_nom)/theta_nom];
plot(100*(di_vary-di_nom)/di_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = 'd_i '; l_int = l_int + 1;
%% Vary deflection
spring = Convert_Build_Params(spring_nom);
delta_vary = linspace(.75*delta_nom,1.25*delta_nom,101);
thetas = zeros(size(delta_vary));
for k = 1:length(delta_vary)
    thetas(k) = compute_theta(spring,delta_vary(k));
end
delta_p = [delta_p; 100*(thetas-theta_nom)/theta_nom];
plot(100*(delta_vary-delta_nom)/delta_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = '\delta '; l_int = l_int + 1;
%% Vary Nt
spring = Convert_Build_Params(spring_nom);
Nt_nom = spring.N_t;
Nt_vary = linspace(.75*Nt_nom,1.25*Nt_nom,101);
thetas = zeros(size(Nt_vary));
for k = 1:length(Nt_vary)
    spring = spring_nom;
    spring.N_t = Nt_vary(k);
    spring = Convert_Build_Params(spring);
    thetas(k) = compute_theta(spring,delta_nom);
end
Nt_p = [Nt_p; 100*(thetas-theta_nom)/theta_nom];
plot(100*(Nt_vary-Nt_nom)/Nt_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = 'N_t '; l_int = l_int + 1;
%% Vary Lf
spring = Convert_Build_Params(spring_nom);
Lf_nom = spring.L_free;
Lf_vary = linspace(.75*Lf_nom,1.25*Lf_nom,101);
thetas = zeros(size(Lf_vary));
for k = 1:length(Lf_vary)
    spring = spring_nom;
    spring.L_free = Lf_vary(k);
    spring = Convert_Build_Params(spring);
    thetas(k) = compute_theta(spring,delta_nom);
end
Lf_p = [Lf_p; 100*(thetas-theta_nom)/theta_nom];
plot(100*(Lf_vary-Lf_nom)/Lf_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = 'L_{free} '; l_int = l_int + 1;
%% Vary nu
spring = Convert_Build_Params(spring_nom);
nu_nom = spring.nu;
nu_vary = linspace(.75*nu_nom,1.25*nu_nom,101);
thetas = zeros(size(nu_vary));
for k = 1:length(nu_vary)
    spring.nu = nu_vary(k);
    thetas(k) = compute_theta(spring,delta_nom);
end
nu_p = [nu_p; 100*(thetas-theta_nom)/theta_nom];
plot(100*(nu_vary-nu_nom)/nu_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = '\nu '; l_int = l_int + 1;
%% Vary dw
spring = Convert_Build_Params(spring_nom);
dw_nom = spring.d_w;
dw_vary = linspace(.75*dw_nom,1.25*dw_nom,101);
thetas = zeros(size(dw_vary));
for k = 1:length(dw_vary)
    spring = spring_nom;
    spring.d_w = dw_vary(k);
    spring = Convert_Build_Params(spring);
    thetas(k) = compute_theta(spring,delta_nom);
end
dw_p = [dw_p; 100*(thetas-theta_nom)/theta_nom];
plot(100*(dw_vary-dw_nom)/dw_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = 'd_w '; l_int = l_int + 1;
end
%% Plot all parameters area plots
figure;
a = area(linspace(-25,25,101),([(min(abs(di_p)).*sign(di_p(1,:)))' (range(di_p).*sign(di_p(1,:)))'])); hold on;
a(1).FaceColor = 'none'; a(1).LineStyle = 'none'; a(2).FaceAlpha = .5;

b = area(linspace(-25,25,101),([(min(abs(delta_p)).*sign(delta_p(1,:)))' (range(delta_p).*sign(delta_p(1,:)))'])); hold on;
b(1).FaceColor = 'none'; b(1).LineStyle = 'none'; b(2).FaceAlpha = .5;

c = area(linspace(-25,25,101),([(min(abs(Nt_p)).*sign(Nt_p(1,:)))' (range(Nt_p).*sign(Nt_p(1,:)))'])); hold on;
c(1).FaceColor = 'none'; c(1).LineStyle = 'none'; c(2).FaceAlpha = .5;

d = area(linspace(-25,25,101),([(min(abs(Lf_p)).*sign(Lf_p(1,:)))' (range(Lf_p).*sign(Lf_p(1,:)))'])); hold on;
d(1).FaceColor = 'none'; d(1).LineStyle = 'none'; d(2).FaceAlpha = .5;

e = area(linspace(-25,25,101),([(min(abs(nu_p)).*sign(nu_p(1,:)))' (range(nu_p).*sign(nu_p(1,:)))'])); hold on;
e(1).FaceColor = 'none'; e(1).LineStyle = 'none'; e(2).FaceAlpha = .5;

f = area(linspace(-25,25,101),([(min(abs(dw_p)).*sign(dw_p(1,:)))' (range(dw_p).*sign(dw_p(1,:)))'])); hold on;
f(1).FaceColor = 'none'; f(1).LineStyle = 'none'; f(2).FaceAlpha = .5;
%% Plot Properties
set(gca,'fontsize', 20)
axis tight; grid on
xlabel("%\Delta Parameter")
ylabel('%\Delta \theta')
legend([a(2) b(2) c(2) d(2) e(2) f(2)],l,'location','southwest','Orientation','horizontal');