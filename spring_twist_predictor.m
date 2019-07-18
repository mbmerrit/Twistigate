% Initial code codifying equation (39) of Michalczyk
clear, clc, close all
%% Spring geometry variables

% structure definitions
possible_end_conditions = {'open','closed','closed_ground'};

% degrees
gamma = 10;
gamma = gamma*pi/180;

end_condition = possible_end_conditions{1};

% number of active coils
n_0cz = [4.5, 6.5, 8.5, 10.5, 15.5];

% height of active coils, uncompressed, m
H_0cz = 0.076;

% spring compression, m
% delta = 0.04;
delta = linspace(H_0cz*.01, H_0cz*.6, 1000); % variable spring compression

% Poisson's ratio
nu = 0.3;

% wire diameter, m
% D = linspace(0.005, 0.03, 1000);
D = 0.03;

%% Some derived variables

% compressed height
H_1cz = H_0cz - delta;


theta = zeros(1000,numel(n_0cz));
for j = 1:numel(n_0cz)
    % wire length
    L = sqrt((pi * D * n_0cz(j)).^2 + (H_0cz)^2);

    % mean radius of uncompressed spring
    R_0 = D/2;

    for i = 1:1000
        theta(i,j) = compute_theta(n_0cz(j), L, H_0cz, H_1cz(i), R_0, nu); % variable deflection
%         theta(i,j) = compute_theta(n_0cz(j), L(i), H_0cz, H_1cz, R_0(i), nu);
    end
    plot(delta*1000, theta(:,j)*180/pi, 'LineWidth', 3)
%     plot(D*1000, theta(:,j)*180/pi, 'LineWidth', 3)
    hold on
    l{j} = strcat('n = ', num2str(n_0cz(j)));
end

title(['Wire diameter: ' num2str(D*1e3) 'mm'], 'FontSize', 20, 'FontWeight', 'bold') 
% title('Deflection vs Twist', 'FontSize', 20, 'FontWeight', 'bold') 
% title('Mean Diameter vs Twist', 'FontSize', 20, 'FontWeight', 'bold') 
xlabel('Deflection, mm', 'FontSize', 18)
% xlabel('Mean Diameter, mm', 'FontSize', 18)
ylabel('Twist Angle, degrees', 'FontSize', 18)
grid on
legend(l, 'FontSize', 20)
set(legend,'location','northwest')
ax = gca;
ax.FontSize = 18;

