% Plot twist angle as a function of wire diameter

load_path
spring = nominal_spring();

% entered in mm and converted to meter
d_w = linspace(0.1,4,1000)/1000;

% preallocate
theta = zeros(numel(d_w), 1);

% loop through parameters
for i = 1:numel(d_w)
    spring.d_w = d_w(i);
    spring = Convert_Build_Params(spring);
    delta = 0.85 * spring.delta_max;
    theta(i) = compute_theta(spring, delta);
    
end

% plot
plot(d_w*1000, theta, 'LineWidth', 3)
xlabel('\textit{Wire Diameter (mm)}', 'Interpreter', 'latex', ...
       'FontSize', 16)
ylabel('\textit{$\theta$ (degree)}', 'Interpreter', 'latex', ...
       'FontSize', 16)
title('Wire Diameter vs Twist Angle', 'FontSize', 18, 'FontWeight', ...
      'bold')