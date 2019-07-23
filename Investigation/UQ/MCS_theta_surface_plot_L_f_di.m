clear;clc;close all

load_path

% load nominal spring
spring = nominal_spring();

% generate random samples
rng('default'); % same random seed for reproductability
N_mc = 1e6; % number of MCS samples
uncertainty = .25;
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

theta = compute_theta_vectorize(spring_MCS,delta);

% get a theta from nominal values
spring_nominal = Convert_Build_Params_vectorize(spring);
delta_nominal = spring_nominal.L_free - L_hat;
theta_nominal = compute_theta_vectorize(spring_nominal,delta_nominal);

dis_idx = linspace(min(theta),max(theta),11);
[group_idx] = discretize(theta,dis_idx,dis_idx(1:end-1));

fig_surf = figure();
fig_surf.Position = [100 100 1500 500];
subplot(121);hold on;
f1=gscatter(X_3*1e3,X_1*1e3,group_idx,[],[],[],'off');

mymarkersize = .5;

for k = 1:length(f1)
    f1(k).MarkerSize = mymarkersize;
    if k == 1
        leg{k} = [num2str(dis_idx(k),'%.1f') '$\leq\theta \leq$' num2str(dis_idx(k+1),'%.1f')];
    else
    leg{k} = [num2str(dis_idx(k),'%.1f') '$<\theta \leq$' num2str(dis_idx(k+1),'%.1f')];
    end
end
legend(leg)
set(legend,'location','eastoutside','interpreter','latex',...
    'visible','off','fontsize',15);

xlabel('$L_f~$(mm)','fontsize',20,'interpreter','latex');
ylabel('$d_i~$(mm)','fontsize',20,'interpreter','latex');
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
axis square tight

subplot(122);hold on;
f2=gscatter(X_4,X_1*1e3,group_idx,[],[],[],'off');
f2fake=gscatter(X_4,X_1*1e3,group_idx,[],[],[],'off');
set(f2fake,'visible','off','markersize',30);
xlabel('$N_t$','fontsize',20,'interpreter','latex');
ylabel('$d_i~$(mm)','fontsize',20,'interpreter','latex');
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
axis square tight

for k = 1:length(f2)
    f2(k).MarkerSize = mymarkersize;
    if k == 1
        leg{k} = [num2str(dis_idx(k),'%.1f') '$\leq\theta \leq$' num2str(dis_idx(k+1),'%.1f')];
    else
    leg{k} = [num2str(dis_idx(k),'%.1f') '$<\theta \leq$' num2str(dis_idx(k+1),'%.1f')];
    end
end
legend(f2fake,leg)
set(legend,'location','eastoutside','interpreter','latex','fontsize',15);



set(gcf,'PaperPositionMode','auto')
% print(['figures/surface_L_f_vs_d_i_parameters.fig'],'-deps','-r0','-painters')
savefig(['figures/surface_L_f_vs_d_i_parameters.fig'])

