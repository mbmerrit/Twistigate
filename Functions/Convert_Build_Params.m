function [Conversion_Output] = Convert_Build_Params(spring)
% SAMSI IMSM Team Twistigate 2019
% Takes build parameters as inputs and outputs parameters in terms of the
% current working formulas. Specify lengths in terms of meters. 
% The 5 necessary inputs are wire diameter (d_w), inner diameter (d_i),
% number of total coils (N_t), end conditions, and free length (L_free). 
if length(fieldnames(spring)) < 5
    disp('invalid number of inputs')
end

% Unpack the input struct: spring
d_w = spring.d_w;
d_i = spring.d_i;
N_t = spring.N_t;
end_condition = spring.end_condition;
L_free = spring.L_free;

% Obtain pitch p using the end conditions
if strcmp(end_condition,'open') == 1
    n_0 = N_t;
    p = L_free/(n_0 - 1);
    H_0 = (n_0 - 1) * p;   % this is just L_free
    L_solid = (n_0 + 1)*d_w;  % solid height
elseif strcmp(end_condition, 'closed_ground') == 1
    n_0 = N_t - 2;
    p = (L_free - 2*d_w)/(n_0);
    H_0 = (n_0 - 1)*p;  %
    L_solid = N_t*d_w;  % solid height
elseif strcmp(end_condition, 'open_ground') == 1
    n_0 = N_t - 1;
    p = L_free/(n_0 - 1);
    H_0 = (n_0 - 1)*p; % again, this is just L_free
    L_solid = N_t*d_w;  % solid height
else
    disp('invalid end condition')
end

delta_max = L_free - L_solid;   % the maximum deflection
d_o = d_i + 2*d_w; % the outer diameter
nu = 0.3; % Poisson ratio, this is the valued we've agreed to use
R_0 = (d_i + d_w)/2;  % radius 
D_0 = 2*R_0; % uncrompressed diameter
l_w = sqrt(H_0^2 + (n_0*2*pi*R_0)^2);  % the length of the wire
alpha_0 = asin(H_0/l_w);

Conversion_Output = struct;
Conversion_Output.n_0 = n_0;
Conversion_Output.l_w = l_w;
Conversion_Output.L_soild = L_solid;
Conversion_Output.H_0 = H_0;
Conversion_Output.D_0 = D_0;
Conversion_Output.R_0 = R_0;
Conversion_Output.alpha_0 = alpha_0;
Conversion_Output.nu = nu;
Conversion_Output.spring = spring;
Conversion_Output.delta_max = delta_max;

end