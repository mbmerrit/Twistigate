% Code codifying equation derived using Michalczyk's ideas,
% MN in terms of D_1 and F in terms of D_0 and N_0
%
clear, clc
%% Spring geometry variables

% structure definitions
possible_end_conditions = {'open','closed','closed_ground'};

% degrees
gamma = 10;
gamma = gamma*pi/180;

Dsize=1000;

end_condition = possible_end_conditions{1};

% number of active coils
n_0cz = [4.5, 6.5, 8.5, 10.5, 15.5];

% height of active coils, uncompressed, m
H_0cz = 0.0760;

% spring compression, m
delta = 0.04;

% Poisson's ratio
nu = 0.3;

% wire diameter, m
D = linspace(0.005, 0.03, Dsize);

%% Some derived variables

% compressed height
H_1cz = H_0cz - delta;

R1 = zeros(Dsize,numel(n_0cz));
theta = zeros(Dsize,numel(n_0cz));
n1 = zeros(Dsize,numel(n_0cz));
theta_new = zeros(Dsize,numel(n_0cz));
nratio = zeros(Dsize,numel(numel(n_0cz)));
for j = 1:numel(n_0cz)
    % wire length
    L = sqrt((pi * D * n_0cz(j)).^2 + (H_0cz)^2);

    % mean radius of uncompressed spring
    R_0 = D/2;
    
    for i = 1:Dsize        
        n1(i,j) = n1quad(n_0cz(j), L(i), H_0cz, H_1cz, R_0(i), nu);
        theta_new(i,j)=2*pi*(n_0cz(j)-n1(i,j));
    end
    
   plot(D*Dsize, theta_new(:,j)*180/pi, 'LineWidth', 3)
  
    hold on
    l{j} = strcat('n = ', num2str(n_0cz(j)));
end

 title('Mean Diameter vs theta(FwithD0,MNwithD1)') 
 xlabel('Mean Diameter, mm')
 ylabel('theta(FwithD0,MNwithD1)')
 grid on
 legend(l)
