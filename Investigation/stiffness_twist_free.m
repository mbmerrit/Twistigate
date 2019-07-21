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
nom_spring = spring;

% Poisson's Ratio
G = spring.G;

% create a bunch of combinations
d_i    = linspace(10, 50, 100) / 1000;
L_free = linspace(0.075, 0.4, 100);
N_t    = linspace(5, 50, 100);


% constraints
F = 6.09;
L_hat = 0.025;
max_alpha_0 = 20;
max_L_solid = L_hat;

% prep the data structure
combos.d_i = zeros(numel(d_i)*numel(L_free)*numel(N_t), 1);
combos.L_free = combos.d_i;
combos.N_t = combos.d_i;

count = 1;
for i = 1:numel(d_i)
    for j = 1:numel(L_free)
        for k = 1:numel(N_t)
            combos.d_i(count) = d_i(i);
            combos.L_free(count) = L_free(j);
            combos.N_t(count) = N_t(k);
            count = count + 1;
        end
    end
end

% keep track of variables
stiffness     = NaN(size(combos.d_i,1),1);
spring_index  = stiffness;
theta         = stiffness;
free_length   = stiffness;
inner_diam    = stiffness;
wire_diam     = stiffness;
num_coils     = stiffness;

% keep track of falure variables
fail_solid_stiffness     = stiffness;
fail_solid_spring_index  = stiffness;
fail_solid_theta         = stiffness;
fail_solid_free_length   = stiffness;
fail_solid_inner_diam    = stiffness;
fail_solid_wire_diam     = stiffness;

fail_alpha_stiffness     = stiffness;
fail_alpha_spring_index  = stiffness;
fail_alpha_theta         = stiffness;
fail_alpha_free_length   = stiffness;
fail_alpha_inner_diam    = stiffness;
fail_alpha_wire_diam     = stiffness;

parfor i = 1:size(combos.d_i,1)
    spring = nominal_spring();
    
    % print status
    if mod(i, 10000) == 0
        disp(strcat(num2str(i / size(combos.d_i,1)*100),[' % Done']))
    end

    % update the spring parameters
    spring.d_i    = combos.d_i(i);
    spring.L_free = combos.L_free(i);
    spring.N_t    = combos.N_t(i);

    delta = spring.L_free - L_hat;
    design_point = F / (delta);
    
    % use iterative scheme to find d_w
    spring.d_w = solve_dw(spring, design_point, delta);
    spring = Convert_Build_Params(spring);
    
    % compute stiffness
    n_1 = compute_n1(spring, delta);
    R_1 = compute_r1(spring, delta);
    D_1 = 2*R_1;
    
    % check constraints
    if spring.alpha_0*180/pi > max_alpha_0
        fail_alpha_stiffness(i) = G * spring.d_w^4 / (8 * (D_1)^3 * n_1);
        fail_alpha_spring_index(i) = spring.spring_index;
        fail_alpha_free_length(i)  = spring.L_free;
        fail_alpha_inner_diam(i)   = spring.d_i;
        fail_alpha_wire_diam(i)    = spring.d_w;
        fail_alpha_theta(i) = compute_theta(spring, delta);
        continue;
    elseif spring.L_solid > max_L_solid
        fail_solid_stiffness(i) = G * spring.d_w^4 / (8 * (D_1)^3 * n_1);
        fail_solid_spring_index(i) = spring.spring_index;
        fail_solid_free_length(i)  = spring.L_free;
        fail_solid_inner_diam(i)   = spring.d_i;
        fail_solid_wire_diam(i)    = spring.d_w;
        fail_solid_theta(i) = compute_theta(spring, delta);
        continue;
    end

    stiffness(i) = G * spring.d_w^4 / (8 * (D_1)^3 * n_1);
    spring_index(i) = spring.spring_index;
    free_length(i)  = spring.L_free;
    inner_diam(i)   = spring.d_i;
    wire_diam(i)    = spring.d_w;
    num_coils(i)    = spring.N_t;
    theta(i) = compute_theta(spring, delta);
    
    valid_spring{i} = spring;
end

% optimal spring
[val, ind] = min(theta);
optimal_spring = valid_spring{ind}

% prepare nominal spring for plotting
nom_spring = Convert_Build_Params(nom_spring);
R_1 = compute_r1(nom_spring, nom_spring.L_free - L_hat);
nom_spring.D_1 = 2*R_1;
n_1 = compute_n1(nom_spring, nom_spring.L_free - L_hat);
nom_spring.theta = compute_theta(nom_spring, nom_spring.L_free - L_hat);
nom_spring.stiffness = G * nom_spring.d_w^4 / (8 * (nom_spring.D_1)^3 * n_1);

scatter(stiffness, theta, '+'); hold on
scatter(fail_solid_stiffness, fail_solid_theta, 'd')
scatter(fail_alpha_stiffness, fail_alpha_theta, '^')
scatter(nom_spring.stiffness, nom_spring.theta, 75, 'filled')
xlabel('Stiffness (^{N}/_{m})', 'Fontsize', 16)
ylabel(strcat('\theta (', char(176),')'), 'Fontsize', 16)
title('Relationship Between Twist Angle and Stiffness', 'Fontsize', 18)
legend('Valid Designs','L_s > L_{compress}',strcat('\alpha_0 >  20 ', char(176)),'Nominal Design')
saveas(gcf,'../Figures/With_Missing/theta_k_free_const_n.fig')

figure;
scatter(spring_index, theta, '+'); hold on
scatter(fail_solid_spring_index, fail_solid_theta, 'd')
scatter(fail_alpha_spring_index, fail_alpha_theta, '^')
scatter(nom_spring.spring_index, nom_spring.theta, 75, 'filled')
xlabel('Spring Index', 'Fontsize', 16)
ylabel(strcat('\theta (', char(176),')'), 'Fontsize', 16)
title('Relationship Between Twist Angle and Spring Index', 'Fontsize', 18)
legend('Valid Designs','L_s > L_{compress}',strcat('\alpha_0 >  20 ', char(176)),'Nominal Design')
saveas(gcf,'../Figures/With_Missing/theta_SI_free_const_n.fig')

figure;
scatter(free_length*1000, theta, '+'); hold on
scatter(fail_solid_free_length*1000, fail_solid_theta, 'd')
scatter(fail_alpha_free_length*1000, fail_alpha_theta, '^')
scatter(nom_spring.L_free*1000, nom_spring.theta, 75, 'filled')
xlabel('L_{free} (mm)', 'Fontsize', 16)
ylabel(strcat('\theta (', char(176),')'), 'Fontsize', 16)
title('Relationship Between Twist Angle and Free Length', 'Fontsize', 18)
legend('Valid Designs','L_s > L_{compress}',strcat('\alpha_0 >  20 ', char(176)),'Nominal Design')
saveas(gcf,'../Figures/With_Missing/theta_Lf_free_const_n.fig')

figure;
scatter(inner_diam*1000, theta, '+'); hold on
scatter(fail_solid_inner_diam*1000, fail_solid_theta, 'd')
scatter(fail_alpha_inner_diam*1000, fail_alpha_theta, '^')
scatter(nom_spring.d_i*1000, nom_spring.theta, 75, 'filled')
xlabel('d_{i} (mm)', 'Fontsize', 16)
ylabel(strcat('\theta (', char(176),')'), 'Fontsize', 16)
title('Relationship Between Twist Angle and Inner Diameter', 'Fontsize', 18)
legend('Valid Designs','L_s > L_{compress}',strcat('\alpha_0 >  20 ', char(176)),'Nominal Design')
saveas(gcf,'../Figures/With_Missing/theta_di_free_const_n.fig')

figure;
scatter(wire_diam*1000, theta, '+'); hold on
scatter(fail_solid_wire_diam*1000, fail_solid_theta, 'd')
scatter(fail_alpha_wire_diam*1000, fail_alpha_theta, '^')
scatter(nom_spring.d_w*1000, nom_spring.theta, 75, 'filled')
xlabel('d_{w} (mm)', 'Fontsize', 16)
ylabel(strcat('\theta (', char(176),')'), 'Fontsize', 16)
title('Relationship Between Twist Angle and Wire Diameter', 'Fontsize', 18)
legend('Valid Designs','L_s > L_{compress}',strcat('\alpha_0 >  20 ', char(176)),'Nominal Design')
saveas(gcf,'../Figures/With_Missing/theta_dw_free_const_n.fig')

function d_w = solve_dw(in_spring, design_point, delta)
    G = in_spring.G;
    tol = 1e-6;
    descend_rate = 0.01;
    in_spring = Convert_Build_Params(in_spring);

    % initial guess for d_w to satisfy F/(L_free - L_hat)
    in_spring.d_w = (design_point*8*in_spring.d_i^3*in_spring.n_0/G)^(1/4);
        
    iters = 0;
    while iters < 100
        in_spring = Convert_Build_Params(in_spring);
        
        n_1 = compute_n1(in_spring, delta);
        R_1 = compute_r1(in_spring, delta);
        D_1 = 2*R_1;

        %        in_spring.d_w = (design_point*8*D_1^3*n_1/G)^(1/4);

        diff = design_point - G*in_spring.d_w^4 / (8*D_1^3*n_1);
        
        if abs(diff) < tol
            break
        elseif diff < 0
            in_spring.d_w = in_spring.d_w * (1-descend_rate);
        else
            in_spring.d_w = in_spring.d_w * (1+descend_rate); 
        end
    
        iters = iters + 1;
    end

    % assign output parameter
    d_w = in_spring.d_w;
end