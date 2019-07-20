clear all; close all; clc;
load_path
spring = nominal_spring();
spring = Convert_Build_Params(spring);
Nt_vary = 5:.5:9;
for j = 1:length(Nt_vary);
spring = nominal_spring();
spring.N_t = Nt_vary(j);
spring = Convert_Build_Params(spring);
delta_vary = linspace(0,spring.delta_max,1000);
D1_vals = zeros(size(delta_vary));
n1_vals = zeros(size(delta_vary));
for k = 1:length(delta_vary);
    D1_vals(k) = compute_r1(spring,delta_vary(k))*2;
    n1_vals(k) = compute_n1(spring,delta_vary(k));
end
figure(1)
plot(delta_vary*1000,D1_vals*1000,'LineWidth',2); hold on;
figure(2)
plot(delta_vary*1000,n1_vals-Nt_vary(j),'LineWidth',2); hold on;
l{j} = ['N_T = ' num2str(Nt_vary(j))];
end
figure(1);
set(gca,'fontsize', 20)
axis tight; grid on
xlabel("Deflection, \delta (mm)")
ylabel('D1 (mm)')
legend(l,'location','northwest');
figure(2);
set(gca,'fontsize',20)
axis tight; grid on;
xlabel('Deflection, \delta (mm)');
ylabel('Change in Active Coils, n_1 - n_0');
legend(l,'location','southwest');
