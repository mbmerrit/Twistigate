clear all; close all; clc;
%% Load the spring
spring = nominal_spring;
%% Set up the varying values for nu
nu_vary = linspace(.2,.4,100);
%%
ns = 3:2:11;
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
%%
set(gca,'fontsize', 20)
axis tight; grid on
xlabel('\nu')
ylabel('\theta')
ylim([0 100]);
legend(l);