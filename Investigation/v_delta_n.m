% Plot twist angle as a function of wire diameter
clear, clc, close all

load_path
spring = nominal_spring();

% entered in mm and converted to meter
L_hat = linspace(20,100,1000)/1000;
delta = spring.L_free - L_hat;

% change the number of coils as well
N_t = [5:9];

% preallocate
theta = zeros(numel(L_hat), numel(N_t));
F = theta;
stiffness = theta;

% loop through parameters
for j = 1:numel(N_t)
    spring.N_t = N_t(j);
    for i = 1:numel(L_hat)
        spring.L_hat = L_hat(i);
        spring = spring_metrics(spring);

        theta(i,j)     = spring.theta;
    end
    plot(delta*1000, theta(:,j), 'LineWidth', 3)
    hold on
    l{j} = strcat('N_t = ', num2str(N_t(j)));
end

% plot

xlabel('\textit{$\delta (mm)$}', 'Interpreter', 'latex', 'FontSize', 16)
ylabel('\textit{$\theta$ (degree)}', 'Interpreter', 'latex', 'FontSize', 16)
title('\textit{Twist Angle vs Deflection}', 'FontSize', 18, 'FontWeight', 'bold', 'Interpreter', 'latex')
legend(l, 'FontSize', 16)
grid on
saveas(gcf, '../Figures/theta_v_delta.fig');

figure;
% loop through parameters
for j = 1:numel(N_t)
    spring.N_t = N_t(j);
    for i = 1:numel(L_hat)
        spring.L_hat = L_hat(i);
        spring = spring_metrics(spring);

        F(i,j)         = spring.F_1;
    end
    plot(delta*1000, F(:,j), 'LineWidth', 3)
    hold on
    l{j} = strcat('N_t = ', num2str(N_t(j)));
end

% plot

xlabel('\textit{$\delta (mm)$}', 'Interpreter', 'latex', 'FontSize', 16)
ylabel('\textit{$F$ (N)}', 'Interpreter', 'latex', 'FontSize', 16)
title('\textit{Force vs Deflection}', 'FontSize', 18, 'FontWeight', 'bold', 'Interpreter', 'latex')
legend(l, 'FontSize', 16)
grid on
saveas(gcf, '../Figures/f_v_delta.fig');

figure;
% loop through parameters
for j = 1:numel(N_t)
    spring.N_t = N_t(j);
    for i = 1:numel(L_hat)
        spring.L_hat = L_hat(i);
        spring = spring_metrics(spring);

        stiffness(i,j) = spring.k_1;
    end
    plot(delta*1000, stiffness(:,j), 'LineWidth', 3)
    hold on
    l{j} = strcat('N_t = ', num2str(N_t(j)));
end

% plot

xlabel('\textit{$\delta (mm)$}', 'Interpreter', 'latex', 'FontSize', 16)
ylabel('\textit{$k$ (N/m)}', 'Interpreter', 'latex', 'FontSize', 16)
title('\textit{Stiffness vs Deflection}', 'FontSize', 18, 'FontWeight', 'bold', 'Interpreter', 'latex')
legend(l, 'FontSize', 16)
grid on
saveas(gcf, '../Figures/k_v_delta.fig');
