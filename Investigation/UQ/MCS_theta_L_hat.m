clear;clc;close all

load_path

% load nominal spring
spring = nominal_spring();

% generate random samples
N_mc = 1e6; % number of MCS samples

uncertainty_list = [0.025 0.050 0.100 0.250];

for k = 1:length(uncertainty_list);

uncertainty = uncertainty_list(k);
rng('default'); % same random seed for reproductability
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
spring_MCS.end_condition = 'open_ground';

% convert parameters
spring_MCS = Convert_Build_Params_vectorize(spring_MCS);

L_hat = 0.025;
delta = spring_MCS.L_free - L_hat;

theta(:,k) = compute_theta_vectorize(spring_MCS,delta);

% % esimate pdf by ksdensity
% [pdf_theta,theta_range] = ksdensity(theta,'function','pdf');

% % esimate cdf by ksdensity
% [cdf_theta,theta_range] = ksdensity(theta,'function','cdf');
end


% get a theta from nominal values
spring_nominal = Convert_Build_Params_vectorize(spring);
delta_nominal = spring_nominal.L_free - L_hat;
theta_nominal = compute_theta_vectorize(spring_nominal,delta_nominal);

% get relative tolerance
for j = 1:length(uncertainty_list)
    Save_tol(j,1) = (min(theta(:,j))-theta_nominal)/theta_nominal;
    Save_tol(j,2) = (max(theta(:,j))-theta_nominal)/theta_nominal;
    Save_tol(j,3) = (mean(theta(:,j))-theta_nominal)/theta_nominal;
end
Save_tol = Save_tol*100;

h_fig = figure();
h_fig.Position = [50 50 1500 400];
subplot(121);hold on;
fig1 = histogram(theta(:,1),20,'normalization','pdf');
fig2 = histogram(theta(:,2),50,'normalization','pdf');
fig3 = histogram(theta(:,3),50,'normalization','pdf');
fig4 = histogram(theta(:,4),50,'normalization','pdf');
% fig2 = plot(theta_range,pdf_theta,'r-','linewidth',1);
% fig3 = plot(theta_nominal*ones(1,100),linspace(0,1,100),'b--','linewidth',2);
l1=legend([fig1 fig2 fig3 fig4],'$\epsilon= \phantom{0} 2.5\%$','$\epsilon= \phantom{0} 5.0\%$',...
    '$\epsilon= 10.0\%$','$\epsilon= 25.0\%$');legend boxoff

set(fig1 , 'facecolor' , 'b' , 'facealpha' , .5 , 'linewidth' , .4 , 'edgecolor' , [0 0 0]);
set(fig2 , 'facecolor' , 'r' , 'facealpha' , .5 , 'linewidth' , .4 , 'edgecolor' , [0 0 0]);
set(fig3 , 'facecolor' , 'g' , 'facealpha' , .5 , 'linewidth' , .4 , 'edgecolor' , [0 0 0]);
set(fig4 , 'facecolor' , 'm' , 'facealpha' , .5 , 'linewidth' , .4 , 'edgecolor' , [0 0 0]);

% txt = {['$\theta_{nom}=~$' num2str(theta_nominal,3)],...
%     ['$\theta_{mean}=~$' num2str(mean(theta),3)],...
%     ['$\theta_{min}=~$' num2str(min(theta),3)],...
%     ['$\theta_{max}=~$' num2str(max(theta),3)],...
%     ['$\frac{\theta_{max}-\theta_{nom}}{\theta_{nom}}=~$' num2str((max(theta)-theta_nominal)/theta_nominal,2)],...;
%     ['$\frac{\theta_{nom}-\theta_{min}}{\theta_{nom}}=~$' num2str((theta_nominal-min(theta))/theta_nominal,2)]};
% f_text=text(34,0.17,txt);
% set(f_text,'interpreter','latex',...
%     'fontsize',15)

% txt2 = {['Variables:'],['~$d_i,~d_w,~L_f,N_t,\nu$']};
% f_text2=text(11,0.18,txt2);
% set(f_text2,'interpreter','latex',...
%     'fontsize',15)

xlabel('$\theta~(^{\circ})$','interpreter','latex','fontsize',20);
ylabel('Counts (normalized)','interpreter','latex','fontsize',20);
set(l1,'interpreter','latex','fontsize',20)
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
    'Xlim'        , [0 100] , ...
    'FontSize'    , 20        , ...
    'LineWidth'   , 1         );
% set(gca,'YTickLabel'  , num2str(transpose(get(gca, 'YTick')), '%.2f'))

[Fx1,x1] = ecdf(theta(:,1));
[Fx2,x2] = ecdf(theta(:,2));
[Fx3,x3] = ecdf(theta(:,3));
[Fx4,x4] = ecdf(theta(:,4));


subplot(122);hold on;
fig5 = plot(x1,Fx1,'b-','linewidth',2);
fig6 = plot(x2,Fx2,'r--','linewidth',2);
fig7 = plot(x3,Fx3,'g-.','linewidth',2);
fig8 = plot(x4,Fx4,'m:','linewidth',2);
l2=legend([fig5 fig6 fig7 fig8],'$\epsilon= \phantom{0}2.5\%$','$\epsilon= \phantom{0}5.0\%$',...
    '$\epsilon= 10.0\%$','$\epsilon= 25.0\%$');legend boxoff

xlabel('$\theta~(^{\circ})$','interpreter','latex','fontsize',20);
ylabel('cdf','interpreter','latex','fontsize',20);
set(l2,'interpreter','latex','fontsize',20)
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
    'XLim'        , [0 100] , ...
    'YLim'        , [0 1] , ...
    'FontSize'    , 20        , ...
    'LineWidth'   , 1         );
set(gcf,'PaperPositionMode','auto')
% title(['$\delta= L_f - \hat{L}, \hat{L}= ' num2str(L_hat*1000) 'mm,~\epsilon=' num2str(uncertainty*100) '\%$'],'interpreter','latex')
% title(['$\epsilon=' num2str(uncertainty*100) '\%$'],'interpreter','latex')
print(['figures/hist_cdf_comparison'],'-dpng','-r0','-painters')
savefig(['figures/hist_cdf_comparison.fig'])