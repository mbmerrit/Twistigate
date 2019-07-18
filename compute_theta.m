function [theta] = Compute_Theta(n0, L, H0, H1, R0, nu)
% SAMSI IMSM Team Twistigate 2019
% Computes \var{theta} using Equation 39 on pg. 360 of Michalczyk (2009)
% in terms of variables found in the paper. 
% Variable units: use meters for these calculations
term1 = (R0/ ((H0/(2*pi*n0))^2 + R0^2));
term2 = H1/L * ((H0 - H1)/(2*pi*R0^2*n0* (1 + nu)));
n1 = (L^2/sqrt(L^2 - H1^2)) * (term1 + term2);
n1_act=n1/(2*pi);
theta = 2*pi*(n0 - n1_act);

% This section computes n1 using the new derivation - 7/18/19
n1_implicit = (L^2 - H1^2) / (2*pi) * R0 / (R0^2 + (H0/(2*pi*n0))^2) * L^2 * (1+nu) ...
      / ((1+nu)*(L^2 - H1^2)^(3/2) - (H0 - H1)*H1*L);
theta = 2*pi*(n0 - n1_implicit);

end