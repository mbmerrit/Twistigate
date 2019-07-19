% Initial code codifying equation (39) of Michalczyk
%clear, clc, close all
%% Spring geometry variables

% structure definitions
possible_end_conditions = {'open','closed','closed_ground'};

% degrees
gamma = 10;
gamma = gamma*pi/180;

end_condition = possible_end_conditions{1};

% number of active coils
n_0 = [15.5];

% height of active coils, uncompressed, m
H_0 = 0.076;

% spring compression, m
delta = 0.04;

% Poisson's ratio
nu = 0.3;

% wire diameter, m
D = linspace(0.005, 0.03, 1000);
D = 0.02;
%% Some derived variables

% compressed height
H_1 = H_0 - delta; 

L = sqrt((pi * D * n_0).^2 + (H_0)^2);

    % mean radius of uncompressed spring
R_0 = D/2;

theta = compute_theta(n_0, L, H_0, H_1, R_0, nu)


