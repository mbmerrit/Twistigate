clear all; close all; clc;
load_path
%% Load the spring
spring = nominal_spring;
%% Set up the varying values for nu
nu_vary = linspace(-.5,.5,500);
%%
ns = 5:2:11;
for j = 1:length(ns)
    spring.N_t = ns(j);
    bp = Convert_Build_Params(spring);
    thetas = zeros(size(nu_vary));
    for k = 1:length(nu_vary)
        bp.nu = nu_vary(k);
        thetas(k) = compute_theta(bp,.085);
    end
    plot(nu_vary,thetas,'LineWidth',3); hold on;
    l{j} = strcat('n_0 = ', num2str(ns(j)));
end
plot([.26 .33 .33 .26 .26],[10 10 53 53 10],'--k','LineWidth',2);
l{j+1} = 'Metals';
%%
set(gca,'fontsize', 20)
axis tight; grid on
xlabel("Poisson's Ratio, \nu")
ylabel('\theta')
ylim([0 60]);
legend(l);