function [theta] = compute_theta(Conversion_Output, delta)
% SAMSI IMSM Team Twistigate 2019
% Computes \theta in degrees using modified final version of (39)
% derived in terms of D_1 and n_1 everywhere,
% in terms of variables found in the paper. 
% Variable units: use meters for all units of length

% Unpack the input:
R_0 = Conversion_Output.R_0;
H_0 = Conversion_Output.H_0;
H_1 = H_0 - delta;
n_0 = Conversion_Output.n_0;
nu = Conversion_Output.nu;
l_w = Conversion_Output.l_w;

n_1 = (l_w^2 - H_1^2) / (2*pi) * R_0 / (R_0^2 + (H_0/(2*pi*n_0))^2) * l_w^2 ...
    * (1+nu) / ((1+nu)*(l_w^2 - H_1^2)^(3/2) - (delta)*H_1*l_w);
theta = 2*pi*(n_0 - n_1);

end
