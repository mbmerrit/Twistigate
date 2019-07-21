%% For a family of springs that we considered, these are the trends.
clear all; close all; clc;
load_path
spring = nominal_spring;
spring = Convert_Build_Params(spring);
delta_nom = .025;
R_1 = compute_r1(spring,delta_nom);
n_1 = compute_n1(spring,delta_nom);
G = 76e9;
%%
F_nom = G*spring.d_w^4*delta_nom/(8*(R_1*2)^3*n_1);
%%
di_vary = .01:.0005:.05;
n0_vary = 3:.25:12;
thetas = zeros(length(di_vary),length(n0_vary));
for j = 1:length(di_vary)
    for m = 1:length(n0_vary)
        err = F_nom;
        spring.d_i = di_vary(j);
        spring.n_0 = n0_vary(m);
        spring.d_w = (F_nom*8*(di_vary(j))^3*n0_vary(m)/(G*delta_nom))^(1/4);
        spring = Convert_Build_Params(spring);
        while abs(err) > .1
            R_1 = compute_r1(spring,delta_nom);
            n_1 = compute_n1(spring,delta_nom);
            F = G*spring.d_w^4*delta_nom/(8*(R_1*2)^3*n_1);
            d_w = (F_nom*8*(R_1*2)^3*n_1/(G*delta_nom))^(1/4);
            spring.d_w = d_w;
            err = F_nom - F;
        end
        thetas(j,m) = compute_theta(spring,delta_nom);
        plot(R_1*2000,thetas(j,m),'.'); hold on;
    end
end
figure;
contourf(n0_vary,di_vary,thetas);