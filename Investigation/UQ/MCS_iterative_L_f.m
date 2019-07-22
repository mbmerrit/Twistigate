clear;clc;close all

load_path

% load nominal spring
spring = nominal_spring();

% generate random samples
rng('default'); % same random seed for reproductability
N_mc = 1e6; % number of MCS samples

F = unifrnd( 7.21-0.05    , 7.21+0.05      ,  N_mc , 1);  % F_hat
L_hat   = unifrnd(0.025 - 0.001 , 0.025 + 0.001  ,  N_mc , 1);  % L_hat
X(:,1)  = unifrnd( .024 -.0005  , .024 + .0005   ,  N_mc , 1);  % d_i
X(:,2)  = unifrnd( .001 -.00005 , .001 + .00005  ,  N_mc , 1);  % d_w
X(:,3)  = unifrnd( 0.1*0.8      , 0.1*1.2        ,  N_mc , 1);  % L_f
X(:,4)  = unifrnd( 6.5          , 7.5            ,  N_mc , 1);  % N_T
X(:,5)  = unifrnd( 0.3*0.9      , 0.3*1.1        ,  N_mc , 1);  % nu

spring.d_i = X(:,1);
spring.d_w = X(:,2);
spring.L_f = X(:,3);
spring.N_T = X(:,4);
spring.nu  = X(:,5);
spring = Convert_Build_Params_vectorize(spring);
delta = spring.L_free - L_hat;
D_1 = 2 * compute_r1_vectorize(spring, delta);
n_1 = compute_n1_vectorize(spring, delta);

disp('iterating');
parfor i = 1:N_mc 
    my_obj_fun = @(Lf) 8*F(i)*(D_1(i))^3*n_1(i) /...
        (spring.G*(spring.d_w(i))^4) - (Lf - L_hat(i));
    L_free(i) = fzero(my_obj_fun,spring.L_free);
end
disp('finished iterations');

spring.L_free = L_free'; % replace L_free calculated

theta = compute_theta_vectorize(spring,L_free'-L_hat);

% get a theta from nominal values
spring_nominal = Convert_Build_Params_vectorize(nominal_spring());
delta_nominal = spring_nominal.L_free - 0.025;
theta_nominal = compute_theta_vectorize(spring_nominal,delta_nominal);

% esimate pdf by ksdensity
[pdf_theta,theta_range] = ksdensity(theta,'function','pdf');
[pdf_L_f,L_f_range] = ksdensity(L_free*1e3,'function','pdf');

figure();hold on;
fig_L_f = histogram(L_free*1e3,'normalization','pdf');
plot(L_f_range,pdf_L_f,'r-');
xlabel('$L_f~$(mm)','interpreter','latex','fontsize',20)
ylabel('pdf','interpreter','latex','fontsize',20)

txt1 = {['$L_{f,min}=~$' num2str(min(L_free)*1e3,3)],...
    ['$L_{f,max}=~$' num2str(max(L_free)*1e3,3)],...
    ['$L_{f,mean}=~$' num2str(mean(L_free)*1e3,3)]};
f_text1=text(70,0.04,txt1);
set(f_text1,'interpreter','latex',...
    'fontsize',15)


set(fig_L_f , 'facecolor' , [0 0 1] , 'edgecolor' , [0 0 0] , 'facealpha' , .4 , 'linestyle' , 'none');
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
print(['figures/L_f_histogram_iter'],'-dpng','-r0','-painters')
savefig(['figures/L_f_histogram_iter.fig'])



figure();hold on;
fig1 = histogram(theta,'normalization','pdf');
fig2 = plot(theta_range,pdf_theta,'r-','linewidth',1);
fig3 = plot(theta_nominal*ones(1,100),linspace(0,1,100),'b--','linewidth',2);
l1=legend([fig3 fig2],'Nominal','MCS');legend boxoff

txt = {['$\theta_{nom}=~$' num2str(theta_nominal,3)],...
    ['$\theta_{mean}=~$' num2str(mean(theta),3)],...
    ['$\theta_{min}=~$' num2str(min(theta),3)],...
    ['$\theta_{max}=~$' num2str(max(theta),3)],...
    ['$\frac{\theta_{max}-\theta_{nom}}{\theta_{nom}}=~$' num2str((max(theta)-theta_nominal)/theta_nominal,2)],...;
    ['$\frac{\theta_{nom}-\theta_{min}}{\theta_{nom}}=~$' num2str((theta_nominal-min(theta))/theta_nominal,2)]};
f_text=text(5,0.04,txt);
set(f_text,'interpreter','latex',...
    'fontsize',15)


xlabel('$\theta~(^{\circ})$','interpreter','latex','fontsize',20);
ylabel('pdf','interpreter','latex','fontsize',20);
set(l1,'interpreter','latex','fontsize',20)
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
    'Xlim'        , [0 60] , ...
    'Ylim'        , [0 0.08] , ...
    'LineWidth'   , 1         );
set(gcf,'PaperPositionMode','auto')
% set(gca,'YTickLabel'  , num2str(transpose(get(gca, 'YTick')), '%.2f'))
% title(['$\delta= L_f - \hat{L}, \hat{L}= ' num2str(L_hat*1000) 'mm,~\epsilon=' num2str(uncertainty*100) '\%$'],'interpreter','latex')
% title(['$\epsilon=' num2str(uncertainty*100) '\%$'],'interpreter','latex')
print(['figures/theta_histogram_iter'],'-dpng','-r0','-painters')
savefig(['figures/theta_histogram_iter.fig'])





