% creates a scatter plot showing the relationship between stiffness
% and twist angle. This file assumes that the free height is a
% constant, along with the deflection. We can change:
%    - N_t    the total number of coils
%    - d_i    the inner diameter of the spring
%    - d_w    the diameter of the wire
% We will use the incredibly sophisticated method of grid search to
% perform the analysis. Perhaps in another file we will perform
% this analysis holding a constant F/(L_f - L_hat) relationship (certain
% force at a certain height)

clear, clc, close all

% put the functions folder in my path
load_path

spring = nominal_spring();

% Poisson's Ratio
G = 79e9;

% Dont depress too far so that we can add more coils and change the
% wire thickness a decent amount
delta = 0.05;

% create a bunch of combinations
d_i = linspace(10, 50, 100) / 1000;
%d_w = linspace(0.5, 3, 20) / 1000;
%n_0 = 5:0.5:15;
d_w = [1,2,3]/1000;
n_0 = 7;

combos.d_i = zeros(numel(d_i)*numel(d_w)*numel(n_0), 1);
combos.d_w = combos.d_i;
combos.n_0 = combos.d_i;

count = 1;
for i = 1:numel(d_i)
    for j = 1:numel(d_w)
        for k = 1:numel(n_0)
            combos.d_i(count) = d_i(i);
            combos.d_w(count) = d_w(j);
            combos.n_0(count) = n_0(k);
            count = count + 1;
        end
    end
end

% compute the stiffness at the compressed state and the deflection
stiffness = zeros(size(combos.d_i,1)/3,1);
theta     = stiffness;

%for i = 1:size(combos.d_i,1)
spring.n_0 = n_0;

for j = 1:3
    spring.d_w = d_w(j)
    for i = 1:size(combos.d_i,1)/3
        % update the spring parameters
        %spring.d_i = combos.d_i(i);
        %spring.d_w = combos.d_w(i);
        %spring.n_0 = combos.n_0(i);

        spring.d_i = d_i(i);
        
        spring = Convert_Build_Params(spring);
        
        % compute stiffness
        n_1 = compute_n1(spring, delta);
        R_1 = sqrt(spring.l_w^2 + (spring.H_0 - delta)^2) / (2*pi*n_1);
        stiffness(i) = G * spring.d_w^4 / (8 * (2*R_1)^3 * n_1);
        
        % compute twist angle
        theta(i) = compute_theta(spring, delta);
    end
    scatter(stiffness, theta)
    hold on
    l{j} = strcat('n_0 = 7, d_w = ', num2str(d_w(j)*1000), 'mm');
end


xlabel('Stiffness (^{N}/_{m})', 'Fontsize', 16)
ylabel(strcat('\theta (', char(176),')'), 'Fontsize', 16)
title('Relationship Between Twist Angle and Stiffness', 'Fontsize', 18)
legend(l, 'Fontsize', 16)