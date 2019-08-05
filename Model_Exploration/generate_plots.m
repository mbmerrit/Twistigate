clear, clc, close all

load_path
spring = nominal_spring();
%Here we plot theta(deflection) and use several numbers of coils
n_coils = 5:9;
for j = 1:length(n_coils)
    spring.N_t = n_coils(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    delta = .0001:1e-4:.085;  % deflection through 85%
    for i = 1:length(delta)
    theta(i) = compute_theta(Conversion_Output, delta(i));
    end
    plot(delta/1000, theta, 'linewidth', 2); hold on 
    l{j} = strcat('n_0 = ', num2str(n_coils(j)));
end

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('delfection (mm)')
ylabel('\theta')
legend(l,'location', 'best')

%% Now plot theta(inner diameter) - Mike
clear

spring = nominal_spring();
%Here we plot theta(deflection) and use several numbers of coils
n_coils = 5:9;
for j = 1:length(n_coils)
    spring.N_t = n_coils(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    inner_diam = .01:1e-4:.06;  % inner diameter through 50 mm
    delta = .05; % fix deflection at 50mm - appx 50% of nominal max
    clear theta
    for i = 1:length(inner_diam)
        spring.d_i = inner_diam(i); % iterate over different d_i
        Conversion_Output = Convert_Build_Params(spring);
        theta(i) = compute_theta(Conversion_Output, delta);
        %disp(num2str(Conversion_Output.R_0))
    end
    plot(inner_diam, theta, 'linewidth', 2); hold on 
    l{j} = strcat('N_t = ', num2str(n_coils(j)));
end

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('Inner Diameter (m)')
ylabel(['\theta ','(\circ)'])
legend(l,'location', 'best')
title(['Fixing ','$$\delta = \frac{\delta_{max}}{2}$$'],...
    'interpreter','latex')

%% plot F(delta)
clear

load_path
spring = nominal_spring();
%Here we plot theta(deflection) and use several numbers of coils
n_coils = 5:1:9;
for j = 1:length(n_coils)
    spring.N_t = n_coils(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    delta = 0:1e-4:.85*Conversion_Output.delta_max;
    clear F
    for i = 1:length(delta)
        rate(i) = compute_k(Conversion_Output, delta(i));
        F(i) = rate(i)*delta(i);

    end
    plot(delta/1000, F, 'linewidth', 2); hold on 
    l{j} = strcat('N_t = ', num2str(n_coils(j)));
end

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('Deflection (m)')
ylabel(['Force (N)'])
legend(l,'location', 'best')
title(['Fixing ','$$\delta = 0 ~to~ .85\delta_{max}$$'],...
    'interpreter','latex')

% Vary Poisson's ratio

clear all; close all; clc;

%% Load the spring
spring = nominal_spring;

%% Set up the varying values for nu
nu_vary = linspace(0,.5,500);

ns = 5:1:9;
for j = 1:length(ns)
    spring.N_t = ns(j);
    spring = Convert_Build_Params(spring);
    thetas = zeros(size(nu_vary));
    for k = 1:length(nu_vary)
        spring.nu = nu_vary(k);
        thetas(k) = compute_theta(spring,.085);
    end
    plot(nu_vary,thetas,'LineWidth',3); hold on;
    l{j} = strcat('n_T = ', num2str(ns(j)));
end
plot([.26 .33 .33 .26 .26],[10 10 53 53 10],'--k','LineWidth',2);
l{j+1} = 'Metals';
%%
set(gca,'fontsize', 20)
axis tight; grid on
xlabel("Poisson's Ratio, \nu")
ylabel('\theta')
ylim([0 60]);
legend(l,'location','northwest');


% Plot twist angle as a function of wire diameter
clear, clc, close all

load_path
spring = nominal_spring();
d_w = linspace(0.1,4,1000)/1000;
N_t = [5:9];

% preallocate
theta = zeros(numel(d_w), numel(N_t));

% loop through parameters
for j = 1:numel(N_t)
    spring.N_t = N_t(j);
    for i = 1:numel(d_w)
        spring.d_w = d_w(i);
        spring = spring_metrics(spring);
        theta(i,j) = spring.theta;
    end
    plot(d_w*1000, theta(:,j), 'LineWidth', 3)
    hold on
    l{j} = strcat('N_t = ', num2str(N_t(j)));
end

% plot
xlabel('\textit{Wire Diameter (mm)}', 'Interpreter', 'latex', ...
       'FontSize', 16)
ylabel('\textit{$\theta$ (degree)}', 'Interpreter', 'latex', ...
       'FontSize', 16)
title('\textit{Twist Angle vs Wire Diameter}', 'FontSize', 18, 'FontWeight', ...
      'bold', 'Interpreter', 'latex')
legend(l, 'FontSize', 16)
grid on
