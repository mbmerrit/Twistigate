clear;clc;close all

load_path

% load nominal spring
spring = nominal_spring();

L_f_factor = 0.20;

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

% esimate pdf by ksdensity
[pdf_theta,theta_range] = ksdensity(theta,'function','pdf');

% esimate cdf by ksdensity
[cdf_theta,theta_range] = ksdensity(theta,'function','cdf');

% get a theta from nominal values
spring_nominal = Convert_Build_Params_vectorize(spring);
delta_nominal = spring_nominal.L_free - L_hat;
theta_nominal = compute_theta_vectorize(spring_nominal,delta_nominal);

figure();hold on;
fig1 = histogram(theta,'normalization','pdf');
fig2 = plot(theta_range,pdf_theta,'r-','linewidth',1);
fig3 = plot(theta_nominal*ones(1,100),linspace(0,.15,100),'b--','linewidth',2);
l1=legend([fig3 fig2],'Nominal','MCS');legend boxoff
xlabel('$\theta~(^{\circ})$','interpreter','latex','fontsize',20);
ylabel('pdf','interpreter','latex','fontsize',20);

txt = {['$\theta_{nom}=~$' num2str(theta_nominal,3)],...
    ['$\theta_{mean}=~$' num2str(mean(theta),3)],...
    ['$\theta_{min}=~$' num2str(min(theta),3)],...
    ['$\theta_{max}=~$' num2str(max(theta),3)],...
    ['$\frac{\theta_{max}-\theta_{nom}}{\theta_{nom}}=~$' num2str((max(theta)-theta_nominal)/theta_nominal,2)],...;
    ['$\frac{\theta_{nom}-\theta_{min}}{\theta_{nom}}=~$' num2str((theta_nominal-min(theta))/theta_nominal,2)]};
f_text=text(5,0.04,txt);
set(f_text,'interpreter','latex',...
    'fontsize',15)

set(l1,'interpreter','latex','fontsize',15)
set(fig1 , 'facecolor' , [0 0 1] , 'edgecolor' , [0 0 0] , 'facealpha' , .4 , 'linestyle' , 'none');
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
    'Xlim'        , [0 60] ,...
    'FontSize'    , 20        , ...
    'LineWidth'   , 1         );
set(gcf,'PaperPositionMode','auto')
% set(gca,'YTickLabel'  , num2str(transpose(get(gca, 'YTick')), '%.2f'))
% print(['figures/theta_histogram_fixed_' num2str(L_f_factor*100) 'L_f'],'-dpng','-r0','-painters')
% savefig(['figures/theta_histogram_fixed_' num2str(L_f_factor*100) 'L_f.fig'])