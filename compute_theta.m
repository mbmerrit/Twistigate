function [theta] = compute_theta(n0, L, H0, H1, R0, nu)
% SAMSI IMSM Team Twistigate 2019
% Computes \var{theta} using Equation 39 on pg. 360 of Michalczyk (2009)
% in terms of variables found in the paper. 
% Variable units: L, 

%L = sqrt((pi * D * n0).^2 + (H0)^2);
%R0 = D/2;
term1 = (R0/ ((H0/(2*pi*n0))^2 + R0^2));
term2 = H1/L * ((H0 - H1)/(2*pi*R0^2*n0* (1 + nu)));
n1 = (L^2/sqrt(L^2 - H1^2)) * (term1 + term2);
n1_act=n1/(2*pi);
% num = L^2 * (1 + nu);
% denom = (L^2 - H1^2)^(3/2)*rho0*(1+nu) - (H0 - H1)*H1*L*rho0;
% n1 = ((L^2 - H1^2) / (2*pi)) * (num/denom);

theta = 2*pi*(n0) - 2*pi*n1_act;