function [theta] = compute_theta(spring, delta)
% SAMSI IMSM Team Twistigate 2019
% Computes \theta in degrees using modified final version of (39)
% derived in terms of D_1 and n_1 everywhere,
% in terms of variables found in the paper. 
% Variable units: use meters for all units of length

n_0 = spring.n_0;
n_1 = compute_n1(spring, delta);

theta_radians = 2*pi*(n_0 - n_1);   %theta in radians
theta=360*(n_0-n_1);                %theta in degrees
end
