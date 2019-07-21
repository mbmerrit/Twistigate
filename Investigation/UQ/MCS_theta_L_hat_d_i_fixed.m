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

% theta with d_i fixed
spring_MCS_d_i_fixed.d_i    = spring.d_i;
spring_MCS_d_i_fixed.d_w    = X_2;
spring_MCS_d_i_fixed.L_free = X_3;
spring_MCS_d_i_fixed.N_t    = X_4;
spring_MCS_d_i_fixed.nu     = X_5;
spring_MCS_d_i_fixed.end_condition = 'open';

spring_MCS_d_i_fixed = Convert_Build_Params_vectorize(spring_MCS_d_i_fixed);

theta_d_i_fixed = compute_theta_vectorize(spring_MCS_d_i_fixed,delta);

% esimate pdf by ksdensity
[pdf_theta,theta_range] = ksdensity(theta,'function','pdf');
[pdf_theta_d_i_fixed,theta_range_d_i_fixed] = ksdensity(theta_d_i_fixed,theta_range,'function','pdf');

% esimate cdf by ksdensity
[cdf_theta,theta_range] = ksdensity(theta,'function','cdf');
[cdf_theta_d_i_fixed,theta_range_d_i_fixed] = ksdensity(theta_d_i_fixed,theta_range,'function','cdf');

% get a theta from nominal values
spring_nominal = Convert_Build_Params_vectorize(spring);
delta_nominal = spring_nominal.L_free - L_hat;
theta_nominal = compute_theta_vectorize(spring_nominal,delta_nominal);

figure();hold on;
fig1 = histogram(theta,'normalization','pdf');
fig2 = plot(theta_range,pdf_theta,'r-','linewidth',1);
fig3 = plot(theta_nominal*ones(1,100),linspace(0,1,100),'b--','linewidth',2);
fig4 = plot(theta_range_d_i_fixed,pdf_theta_d_i_fixed,'g:','linewidth',2);
l1=legend([fig3 fig2 fig4],'Nominal','MCS',['Fixed $d_i= $' num2str(spring.d_i) 'mm']);legend boxoff

% txt = {['$\theta_{nom}=~$' num2str(theta_nominal,3)],...
%     ['$\theta_{mean}=~$' num2str(mean(theta),3)],...
%     ['$\theta_{min}=~$' num2str(min(theta),3)],...
%     ['$\theta_{max}=~$' num2str(max(theta),3)],...
%     ['$\frac{\theta_{max}-\theta_{nom}}{\theta_{nom}}=~$' num2str((max(theta)-theta_nominal)/theta_nominal,2)],...;
%     ['$\frac{\theta_{nom}-\theta_{min}}{\theta_{nom}}=~$' num2str((theta_nominal-min(theta))/theta_nominal,2)]};
% f_text=text(33,0.08,txt);
% set(f_text,'interpreter','latex',...
%     'fontsize',15)

txt2 = {['Variables:'],['~$d_i,~d_w,~L_f,N_t,\nu$']};
f_text2=text(11,0.18,txt2);
set(f_text2,'interpreter','latex',...
    'fontsize',15)


xlabel('$\theta~(^{\circ})$','interpreter','latex','fontsize',20);
ylabel('pdf','interpreter','latex','fontsize',20);
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
    'YLim'        , [0 0.2] , ...
    'XLim'        , [10 50] , ...
    'FontSize'    , 20        , ...
    'LineWidth'   , 1         );
set(gcf,'PaperPositionMode','auto')
% set(gca,'YTickLabel'  , num2str(transpose(get(gca, 'YTick')), '%.2f'))
title(['$\delta= L_f - \hat{L}, \hat{L}= ' num2str(L_hat*1000) 'mm,~\epsilon=' num2str(uncertainty*100) '\%$'],'interpreter','latex')
print(['figures/theta_histogram_L_hat_d_i_fixed' num2str(uncertainty*100) 'uncertainty'],'-dpng','-r0','-painters')
savefig(['figures/theta_histogram_L_hat_d_i_fixed' num2str(uncertainty*100) 'uncertainty.fig'])


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
print(['figures/theta_cdf_L_hat_d_i_fixed' num2str(uncertainty*100) 'uncertainty'],'-dpng','-r0','-painters')
savefig(['figures/theta_cdf_L_hat_d_i_fixed' num2str(uncertainty*100) 'uncertainty.fig'])