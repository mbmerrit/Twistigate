clear;clc;close all

load_path

% load nominal spring
spring = nominal_spring();

% generate random samples
rng('default'); % same random seed for reproductability
N_mc = 1e6; % number of MCS samples
uncertainty = .05;
X_1 = unifrnd( (1-uncertainty)*spring.d_i   , (1+uncertainty)*spring.d_i,    N_mc, 1);
X_2 = unifrnd( (1-uncertainty)*spring.d_w   , (1+uncertainty)*spring.d_w,    N_mc, 1);
X_3 = unifrnd( (1-uncertainty)*spring.L_free, (1+uncertainty)*spring.L_free, N_mc, 1);
X_4 = unifrnd( (1-uncertainty)*spring.N_t   , (1+uncertainty)*spring.N_t,    N_mc, 1);

% pack samples
spring_MCS.d_i    = X_1;
spring_MCS.d_w    = X_2;
spring_MCS.L_free = X_3;
spring_MCS.N_t    = X_4;
spring_MCS.end_condition = 'open';

% convert parameters
spring_MCS = Convert_Build_Params_vectorize(spring_MCS);

delta_factor = 0.85;
delta = delta_factor * spring_MCS.delta_max;

theta = compute_theta_vectorize(spring_MCS,delta);

% esimate pdf by ksdensity
[pdf_theta,theta_range] = ksdensity(theta,'function','pdf');

figure();hold on;
fig1 = histogram(theta,'normalization','pdf');
fig2 = plot(theta_range,pdf_theta,'r-','linewidth',1);
xlabel('$\theta~(^{\circ})$','interpreter','latex','fontsize',20);
ylabel('pdf','interpreter','latex','fontsize',20);
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
    'FontSize'    , 20        , ...
    'LineWidth'   , 1         );
set(gcf,'PaperPositionMode','auto')
set(gca,'YTickLabel'  , num2str(transpose(get(gca, 'YTick')), '%.2f'))
% print(['figures/theta_histogram_' num2str(uncertainty*100) 'uncertainty'],'-deps','-r0','-painters')
print(['figures/theta_histogram_' num2str(uncertainty*100) 'uncertainty'],'-dpng','-r0','-painters')
savefig(['figures/theta_histogram_' num2str(uncertainty*100) 'uncertainty.fig'])
