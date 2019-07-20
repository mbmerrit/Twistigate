% creates a scatter plot showing the relationship between stiffness
% and twist angle. This file does not assume that the free height is a
% constant.However, F/(L_free - L_hat) is constant. We can change:
%    - N_t    the total number of coils
%    - d_i    the inner diameter of the spring
%    - d_w    the diameter of the wire
%    - L_free the free height of the spring
% We will use the incredibly sophisticated method of grid search to
% perform the analysis. 

clear, clc, close all

% put the functions folder in my path
load_path

spring = nominal_spring();

% Poisson's Ratio
G = spring.G;

% create a bunch of combinations
d_i = linspace(10, 50, 100) / 1000;
L_free = linspace(0.1, 0.4, 100);
n_0 = linspace(5, 20, 100);

% constraints
F = 6.09;
L_hat = 0.025;
L_free_nom = 0.1;
design_point = F / (L_free_nom - L_hat)
max_alpha_0 = 20;
max_L_solid = L_hat;

% prep the data structure
combos.d_i = zeros(numel(d_i)*numel(L_free)*numel(n_0), 1);
combos.L_free = combos.d_i;
combos.n_0 = combos.d_i;

count = 1;
for i = 1:numel(d_i)
    for j = 1:numel(L_free)
        for k = 1:numel(n_0)
            combos.d_i(count) = d_i(i);
            combos.L_free(count) = L_free(j);
            combos.n_0(count) = n_0(k);
            count = count + 1;
        end
    end
end

% compute the stiffness at the compressed state and the deflection
stiffness = zeros(size(combos.d_i,1),1);
theta     = stiffness;

%for i = 1:size(combos.d_i,1)
spring.n_0 = n_0;

for i = 1:size(combos.d_i,1)/3
    % update the spring parameters
    spring.d_i    = combos.d_i(i);
    spring.L_free = combos.L_free(i);
    spring.n_0    = combos.n_0(i);

    % does this need iteration to determine?
    spring.d_w = (design_point*8*spring.d_i^3*spring.n_0)^(1/4);
    
    spring = Convert_Build_Params(spring);

    % check constraints
    if spring.L_solid > max_L_solid
        continue;
    elseif spring.alpha_0*180/pi > max_alpha_0
        continue;
    elseif 
    
    % compute stiffness
    n_1 = compute_n1(spring, delta);
    D_1 = compute_D1(spring, n_1, delta);
    stiffness(i) = G * spring.d_w^4 / (8 * (D_1)^3 * n_1);
    
    % compute twist angle
    theta(i) = compute_theta(spring, delta);
end

scatter(stiffness, theta)
xlabel('Stiffness (^{N}/_{m})', 'Fontsize', 16)
ylabel(strcat('\theta (', char(176),')'), 'Fontsize', 16)
title('Relationship Between Twist Angle and Stiffness', 'Fontsize', 18)
legend(l, 'Fontsize', 16)


function d_w = solve_dw(spring, design_point)
    G = spring.G;
end