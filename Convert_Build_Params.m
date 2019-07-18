function [n_0, l_w, H_0, H_1, D_0, R_0, nu, gamma_0] = ...
    Convert_Build_Params(d_i, d_w, d_o, end_condition, L_free, N_T)
% SAMSI IMSM Team Twistigate 2019
% Takes build parameters as inputs and outputs parameters in terms of the
% current working formulas.

% Obtain pitch p using the end conditions
if strcmp(end_condition,'open') == 1
    p = L_free/(N_T - 1);
elseif strcmp(end_condition, 'closed') == 1
    p = (L_free - 2*d_w)/(N_T - 2);
elseif strcmp(end_condition, 'closed_ground') == 1
     p = (L_free - 2*d_w)/(N_T - 2);
else
    disp('invalid end condition')
end

H_0 = (n_0 - 1)*p;
nu = 0.3;

R0 = (d_i + d_w)/2;
gamma_0 = asin(H_0/l_w);

end