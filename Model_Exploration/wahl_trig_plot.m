clear all; close all; clc;
load_path
spring = nominal_spring();
spring = Convert_Build_Params(spring);
Nt_vary = 5:1:9;
for j = 1:length(Nt_vary);
spring = nominal_spring();
spring.N_t = Nt_vary(j);
spring = Convert_Build_Params(spring);
delta_vary = linspace(0,spring.delta_max,1000);
D1_vals = zeros(size(delta_vary));
n1_vals = zeros(size(delta_vary));
D1_vals2 = zeros(size(delta_vary));
n1_vals2 = zeros(size(delta_vary));
for k = 1:length(delta_vary);
    D1_vals(k) = compute_r1(spring,delta_vary(k))*2;
    n1_vals(k) = compute_n1(spring,delta_vary(k));
    
    delta = delta_vary(k);
    R_0 = spring.R_0;
    H_1 = spring.H_0 - delta;
    l_w = spring.l_w;
    alpha_1 = asin(H_1/l_w);
    c_0 = R_0*tan(spring.alpha_0);
    rho_0 = (R_0/(c_0^2 + R_0^2))^-1;
    
    R_1 = rho_0*(cos(alpha_1)^2 - delta*tan(alpha_1)^2/(H_1*(1 + spring.nu)));
    D1_vals2(k) = R_1*2;
    n1_vals2(k) = l_w*cos(alpha_1)/(R_1*2*pi);
end
figure(1)
plot(delta_vary*1000,D1_vals*1000,'LineWidth',2); hold on;
% plot(delta_vary*1000,D1_vals2*1000,'--');
figure(2)
plot(delta_vary*1000,n1_vals-Nt_vary(j)+1,'LineWidth',2); hold on;
% plot(delta_vary*1000,n1_vals2-Nt_vary(j),'--');
l{j} = ['N_T = ' num2str(Nt_vary(j))];
% figure(3)
% plot(delta_vary*1000,360*(Nt_vary(j) - n1_vals),'LineWidth',2); hold on;
% plot(delta_vary*1000,360*(Nt_vary(j) - n1_vals2),'--');
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
% figure(3);
% set(gca,'fontsize',20)
% axis tight; grid on;
% xlabel('Deflection, \delta (mm)');
% ylabel('\theta');
% legend(l,'location','southwest');