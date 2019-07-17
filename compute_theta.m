function [theta] = compute_theta(n0cz, L, H0cz, H1cz, R0, nu)
% SAMSI IMSM Team Twistigate 2019
% Computes \var{theta} using Equation 39 on pg. 360 of Michalczyk (2009)
% in terms of variables found in the paper. 
% Variable units: L, 


term1 = (R0/ ((H0cz/(2*pi*n0cz))^2 + R0^2 ));
term2 = H1cz/L * ((H0cz - H1cz) / (2*pi*R0^2*n0cz* (1 + nu)));

n1cz = (L^2/sqrt(L^2 - H1cz^2)) * (term1 + term2);
theta = 2*pi*n0cz - n1cz;