% Plot other design parameters as functions of deflection
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

        if spring.L_solid > spring.L_hat
            theta(i,j) = NaN;
        else
            theta(i,j)     = spring.theta;
        end        
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
f = gcf;
f.set('Position', [0,0,1920,1080]);
saveas(gcf, '../Figures/theta_v_delta.fig');

figure;
% loop through parameters
for j = 1:numel(N_t)
    spring.N_t = N_t(j);
    for i = 1:numel(L_hat)
        spring.L_hat = L_hat(i);
        spring = spring_metrics(spring);

        if spring.L_solid > spring.L_hat
            F(i,j) = NaN;
        else
            F(i,j)     = spring.F_1;
        end
        
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
f = gcf;
f.set('Position', [0,0,1920,1080]);
saveas(gcf, '../Figures/f_v_delta.fig');

figure;
% loop through parameters
for j = 1:numel(N_t)
    spring.N_t = N_t(j);
    spring = spring_metrics(spring);
    k_0 = spring.k_0;
    for i = 1:numel(L_hat)
        spring.L_hat = L_hat(i);
        spring = spring_metrics(spring);

        if spring.L_solid > spring.L_hat
            stiffness(i,j) = NaN;
        else
            stiffness(i,j)     = (spring.k_1-k_0)/k_0;
        end
        
    end
    plot(delta*1000, stiffness(:,j)*100, 'LineWidth', 3)
    hold on
    l{j} = strcat('N_t = ', num2str(N_t(j)));
end

% plot

xlabel('\textit{$\delta (mm)$}', 'Interpreter', 'latex', 'FontSize', 16)
ylabel('\textit{$\frac{\Delta k}{k_0}$ (\%)}', 'Interpreter', 'latex', 'FontSize', 16)
title('\textit{Stiffness vs Deflection}', 'FontSize', 18, 'FontWeight', 'bold', 'Interpreter', 'latex')
legend(l, 'FontSize', 16)
grid on
f = gcf;
f.set('Position', [0,0,1920,1080]);
saveas(gcf, '../Figures/k_v_delta_percent.fig');
