function [theta] = compute_theta(Conversion_Output, delta)
% SAMSI IMSM Team Twistigate 2019
% Computes \theta in degrees using Equation 39 on pg. 360 of Michalczyk (2009)
% in terms of variables found in the paper. 
% Variable units: use meters for all units of length

% Unpack the input:
R_0 = Conversion_Output.R_0;
H_0 = Conversion_Output.H_0;
H_1 = H_0 - delta;
n_0 = Conversion_Output.n_0;
nu = Conversion_Output.nu;
l_w = Conversion_Output.l_w;

% This is the Michalcyzk version
% term1 = (R_0/ ((H_0/(2*pi*n_0))^2 + R_0^2));
% term2 = H_1/l_w * ((H_0 - H_1)/(2*pi*R_0^2*n_0* (1 + nu)));
% n_1 = (l_w^2/sqrt(l_w^2 - H_1^2)) * (term1 + term2);
% n_1_act=n_1/(2*pi);

n_1 = (l_w^2 - H_1^2) / (2*pi) * R_0 / (R_0^2 + (H_0/(2*pi*n_0))^2) * l_w^2 ...
    * (1+nu) / ((1+nu)*(l_w^2 - H_1^2)^(3/2) - (delta)*H_1*l_w);
theta = 2*pi*(n_0 - n_1);

% This section computes n1 using the new derivation - 7/18/19
% n1_implicit = (L^2 - H1^2) / (2*pi) * R0 / (R0^2 + (H0/(2*pi*n0))^2) * L^2 * (1+nu) ...
%       / ((1+nu)*(L^2 - H1^2)^(3/2) - (H0 - H1)*H1*L);
% theta = 2*pi*(n0 - n1_implicit);

end