clear;clc;close all

load_path

% load nominal spring
spring = nominal_spring();

% generate random samples
rng('default'); % same random seed for reproductability
N_mc = 1e6; % number of MCS samples
uncertainty = .10;
X_1 = unifrnd( (1-uncertainty)*spring.d_i   , (1+uncertainty)*spring.d_i,    N_mc, 1);
X_2 = unifrnd( (1-uncertainty)*spring.d_w   , (1+uncertainty)*spring.d_w,    N_mc, 1);
X_3 = unifrnd( (1-uncertainty)*spring.L_free, (1+uncertainty)*spring.L_free, N_mc, 1);
X_4 = unifrnd( (1-uncertainty)*spring.N_t   , (1+uncertainty)*spring.N_t,    N_mc, 1);
X_5 = unifrnd( (1-uncertainty)*spring.nu    , (1+uncertainty)*spring.nu,     N_mc, 1);

% pack samples
spring_MCS.d_i    = X_1;
spring_MCS.d_w    = X_2;
spring_MCS.L_free = X_3;
spring_MCS.N_t    = X_4;
spring_MCS.nu     = X_5;
spring_MCS.end_condition = 'open';

% convert parameters
spring_MCS = Convert_Build_Params_vectorize(spring_MCS);

L_hat = 0.025;
delta = spring_MCS.L_free - L_hat;

theta = compute_theta_vectorize(spring_MCS,delta);

% get a theta from nominal values
spring_nominal = Convert_Build_Params_vectorize(spring);
delta_nominal = spring_nominal.L_free - L_hat;
theta_nominal = compute_theta_vectorize(spring_nominal,delta_nominal);

% estimate cdf
[cdf_theta,theta_range] = ksdensity(theta,'function','cdf');

% sort theta
[theta_sort,idx] = sort(theta);

% find theta_sort smaller than theta_nominal
find(theta_sort);

% cdf at nominal theta
[cdf_nominal,~] = ksdensity(theta,theta_nominal,'function','cdf');

% figure
figure();hold on;
fig7 = histogram(theta,'normalization','cdf');
fig5 = plot(theta_range,cdf_theta,'r-','linewidth',1);
fig6 = plot(theta_nominal*ones(1,100),linspace(0,1,100),'b--','linewidth',2);
l1=legend([fig6 fig5],'Nominal','MCS');legend boxoff

set(fig7 , 'facecolor' , [0 0 1] , 'edgecolor' , [0 0 0] , 'facealpha' , .4 , 'linestyle' , 'none');

xlabel('$\hat{\theta}~(^{\circ})$','interpreter','latex','fontsize',20);
ylabel('Pr$[\theta < \hat{\theta}]$','interpreter','latex','fontsize',20);
set(l1,'interpreter','latex','fontsize',20)
set(gca           ,             ...
    'Box'         , 'on'      , ...
    'TickDir'     , 'in'      , ...
    'YScale'      , 'linear'     , ...
    'TickLength'  , [.02 .02] , ...
    'ticklabelinterpreter','latex' , ...
    'XMinorTick'  , 'off'     , ...
    'YMinorTick'  , 'off'     , ...
    'YGrid'       , 'on'     , ...
    'XGrid'       , 'on'     , ...
    'XColor'      , 'k'       , ...
    'YColor'      , 'k'       , ...
    'XLim'        , [10 50] , ...
    'YLim'        , [0 1] , ...
    'FontSize'    , 20        , ...
    'LineWidth'   , 1         );
set(gcf,'PaperPositionMode','auto')
title(['$\delta= L_f - \hat{L}, \hat{L}= ' num2str(L_hat*1000) 'mm,~\epsilon=' num2str(uncertainty*100) '\%$'],'interpreter','latex')
% print(['figures/theta_cdf_L_hat_' num2str(uncertainty*100) 'uncertainty'],'-dpng','-r0','-painters')
% savefig(['figures/theta_cdf_L_hat_' num2str(uncertainty*100) 'uncertainty.fig'])