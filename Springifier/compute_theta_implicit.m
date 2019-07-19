function [theta] = compute_theta_implicit(n0, L, H0, H1, R0, nu)
% SAMSI IMSM Team Twistigate 2019
% Computes \var{theta} using Equation 39 on pg. 360 of Michalczyk (2009)
% in terms of variables found in the paper. 

n1 = (L^2 - H1^2) / (2*pi) * R0 / (R0^2 + (H0/(2*pi*n0))^2) * L^2 * (1+nu) ...
      / ((1+nu)*(L^2 - H1^2)^(3/2) - (H0 - H1)*H1*L);
theta = 2*pi*(n0 - n1);