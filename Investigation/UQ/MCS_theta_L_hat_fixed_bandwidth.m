clear;clc;close all

load_path

% load nominal spring
spring = nominal_spring();

L_f_list = [0.0125 0.025 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7];
% L_f_list = [0.025];

for i = 1:length(L_f_list)
L_f_factor = L_f_list(i);

% generate random samples
rng('default'); % same random seed for reproductability
N_mc = 1e6; % number of MCS samples
X(:,1) = unifrnd( .024 -.0005 , .024 + .0005  ,  N_mc, 1);  % d_i
X(:,2) = unifrnd( .001 -.00005 , .001 + .00005  ,  N_mc, 1);  % d_w
X(:,3) = unifrnd( 0.1*(1 - L_f_factor) , 0.1*(1 + L_f_factor) ,  N_mc, 1);  % L_f
X(:,4) = unifrnd( 6.5 , 7.5 ,  N_mc, 1);  % N_T
X(:,5) = unifrnd( 0.3*0.9 , 0.3*1.1 ,  N_mc, 1);  % nu

% pack samples
spring_MCS = spring;
spring_MCS.d_i = X(:,1);
spring_MCS.d_w = X(:,2);
spring_MCS.L_free = X(:,3);
spring_MCS.N_T = X(:,4);
spring_MCS.nu = X(:,5);
spring_MCS.end_condition = 'open_ground';

% convert parameters
spring_MCS = Convert_Build_Params_vectorize(spring_MCS);

L_hat = 0.025;
delta = spring_MCS.L_free - L_hat;

theta = compute_theta_vectorize(spring_MCS,delta);
quant(:,i) = ksdensity(theta,[0.1,0.9],'function','icdf');


% get a theta from nominal values
spring_nominal = Convert_Build_Params_vectorize(spring);
delta_nominal = spring_nominal.L_free - L_hat;
theta_nominal = compute_theta_vectorize(spring_nominal,delta_nominal);

theta_bandwidth(1,i) = (max(theta)-theta_nominal)/theta_nominal;
theta_bandwidth(2,i) = (min(theta)-theta_nominal)/theta_nominal;
theta_bandwidth(3,i) = (quant(1,i)-theta_nominal)/theta_nominal;
theta_bandwidth(4,i) = (quant(2,i)-theta_nominal)/theta_nominal;
end


figure();hold on;
f1=plot(L_f_list*100,theta_bandwidth(1,:)*100,'b.','markersize',20);
f2=plot(L_f_list*100,theta_bandwidth(2,:)*100,'r^','markersize',10);
f3=plot(L_f_list*100,theta_bandwidth(4,:)*100,'b*','markersize',10);
f4=plot(L_f_list*100,theta_bandwidth(3,:)*100,'rx','markersize',10);
legend([f1 f2 f3 f4],'$\theta_{\max}$','$\theta_{\min}$',...
    '$\theta_{90}$','$\theta_{10}$');legend boxoff;
set(legend,'location','northwest','interpreter','latex')
xlabel('$\epsilon~(\%)$ for $L_f$','interpreter','latex','fontsize',20)
ylabel('$(\theta - \theta_{nom})/\theta_{nom}~(\%)$','interpreter','latex','fontsize',20)
set(gca           ,             ...
    'Box'         , 'on'      , ...
    'TickDir'     , 'in'      , ...
    'TickLength'  , [.02 .02] , ...
    'ticklabelinterpreter','latex' , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'YGrid'       , 'on'     , ...
    'XGrid'       , 'on'     , ...
    'XColor'      , 'k'       , ...
    'YColor'      , 'k'       , ...
    'FontSize'    , 20        , ...
    'LineWidth'   , 1         );
% title(['$L_f \sim U[(1 - \epsilon)\theta_{nom}, (1 + \epsilon)\theta_{nom} ]$'],...
%     'interpreter','latex','fontsize',15)
set(gcf,'PaperPositionMode','auto')
print(['figures/bandwidth_theta_vs_L_f'],'-dpng','-r0','-painters')
savefig(['figures/bandwidth_theta_vs_L_f.fig'])

