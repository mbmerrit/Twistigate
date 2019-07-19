% Plot twist angle as a function of wire diameter
clear, clc, close all

load_path
spring = nominal_spring();

% entered in mm and converted to meter
d_w = linspace(0.1,4,1000)/1000;

% change the number of coils as well
N_t = [5,7,9,11,13];

% preallocate
theta = zeros(numel(d_w), numel(N_t));

% loop through parameters
for j = 1:numel(N_t)
    spring.N_t = N_t(j);
    for i = 1:numel(d_w)
        spring.d_w = d_w(i);
        spring = Convert_Build_Params(spring);
        %delta = 0.85 * spring.delta_max;
        delta = 0.05;
        theta(i,j) = compute_theta(spring, delta);
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