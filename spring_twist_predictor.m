% Initial code codifying equation (39) of Michalczyk
clear, clc
%% Spring geometry variables

% structure definitions
possible_end_conditions = {'open','closed','closed_ground'};

% degrees
gamma = 10;
gamma = gamma*pi/180;

end_condition = possible_end_conditions{1};

% inner diameter, m
Di = 0.05;

% wire diameter, m
dw = 0.001;
D  = Di + dw;

% number of active coils
n_0cz = 10;

% height of active coils, uncompressed, m
H_0cz = 0.2;

% spring compression, m
delta = 0.05;

% Poisson's ratio
nu = 0.3;

%% Some derived variables

% compressed height
H_1cz = H_0cz - delta;

% wire length
L = sqrt((pi * D * n_0cz)^2 + (H_0cz)^2);

% mean radius of uncompressed spring
R_0 = D/2;

%% Calculate spring twist
n_1cz = L^2 / sqrt(L^2+H_1cz^2)*(R_0/((H_0cz/(2*pi*n_0cz))^2 + R_0^2) + ...
        delta/(2*pi*R_0^2*n_0cz*(1+nu))*H_1cz/L)/(2*pi);
    
theta = 2*pi*(n_0cz - n_1cz)
theta_deg = theta*180/pi





