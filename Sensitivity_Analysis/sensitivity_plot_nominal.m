%% For a family of springs that we considered, these are the
%% trends.
% This code contributes to the sensitivity analysis,
% plotting the relative change curves for each of the
% design parameters. This file only uses the nominal spring.

clear all; close all; clc;
load_path

%% Colors
cmap = colormap(lines);

%% Load the spring
spring_nom = nominal_spring();

%% Find the nominal twist
spring = Convert_Build_Params(spring_nom);
delta_nom = spring.delta_max*.5;
theta_nom = compute_theta(spring,delta_nom);

%% Set up things for the legend
l_int = 1;

%% Vary Lf (Lhat fixed)
spring = Convert_Build_Params(spring_nom);
Lf_nom = spring.L_free;
L_hat = Lf_nom - delta_nom;
Lf_vary = linspace(.75*Lf_nom,1.25*Lf_nom,101);
thetas = zeros(size(Lf_vary));
for k = 1:length(Lf_vary)
    spring = spring_nom;
    spring.L_free = Lf_vary(k);
    spring = Convert_Build_Params(spring);
    thetas(k) = compute_theta(spring,Lf_vary(k)-L_hat);
end
plot(100*(Lf_vary-Lf_nom)/Lf_nom,100*(thetas-theta_nom)/theta_nom, ...
     '-.','LineWidth',2); hold on

l{l_int} = '$L_{free} (\hat{L}_{fixed})$'; l_int = l_int + 1;
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
plot(100*(di_vary-di_nom)/di_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = '$d_i$ '; l_int = l_int + 1;

%% Vary deflection
spring = Convert_Build_Params(spring_nom);
delta_vary = linspace(.75*delta_nom,1.25*delta_nom,101);
thetas = zeros(size(delta_vary));
for k = 1:length(delta_vary)
    thetas(k) = compute_theta(spring,delta_vary(k));
end
plot(100*(delta_vary-delta_nom)/delta_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = '$\delta$ '; l_int = l_int + 1;

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
plot(100*(Nt_vary-Nt_nom)/Nt_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = '$N_t$ '; l_int = l_int + 1;

%% Vary Lf (delta fixed)
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
plot(100*(Lf_vary-Lf_nom)/Lf_nom,100*(thetas-theta_nom)/theta_nom,'-.','LineWidth',2); hold on;
l{l_int} = '$L_{free} (\delta_{fixed})$'; l_int = l_int + 1;

%% Vary nu
spring = Convert_Build_Params(spring_nom);
nu_nom = spring.nu;
nu_vary = linspace(.75*nu_nom,1.25*nu_nom,101);
thetas = zeros(size(nu_vary));
for k = 1:length(nu_vary)
    spring.nu = nu_vary(k);
    thetas(k) = compute_theta(spring,delta_nom);
end
plot(100*(nu_vary-nu_nom)/nu_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = '$\nu$ '; l_int = l_int + 1;

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
plot(100*(dw_vary-dw_nom)/dw_nom,100*(thetas-theta_nom)/theta_nom,'LineWidth',2); hold on;
l{l_int} = '$d_w$ '; l_int = l_int + 1;

%% Plot Properties
set(gca,'fontsize', 20)
axis tight; grid on
xlabel("%\Delta Parameter")
ylabel('%\Delta \theta')
legend(l,'location','northwest','Orientation','horizontal','Interpreter','latex');