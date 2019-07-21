clear;clc;

load_path

% load nominal spring
spring = nominal_spring();

% uncertainty
e = .1;

% variable selection
sel1 = 1;
sel2 = 2;

% make grid
x(:,1) = linspace( (1 - e)*spring.d_i , (1 + e)*spring.d_i , 4e1);
x(:,2) = linspace( (1 - e)*spring.d_w , (1 + e)*spring.d_w , 4e1);
x(:,3) = linspace( (1 - e)*spring.L_free , (1 + e)*spring.L_free , 4e1);
x(:,4) = linspace( (1 - e)*spring.N_t , (1 + e)*spring.N_t , 4e1);
x(:,5) = linspace( (1 - e)*spring.nu , (1 + e)*spring.nu , 4e1);
[X1,X2] = meshgrid( x(:,sel1) , x(:,sel2) );

% TO BE MODIFIED
if sel1 == 1
    spring.d_i = X1;
    var1_name = 'd_i';
elseif sel1 == 2
    spring.d_w = X1;
    var1_name = 'd_w';
elseif sel1 == 3
    spring.L_free = X1;
    var1_name = 'L_f';
elseif sel1 == 4
    spring.N_t = X1;
    var1_name = 'N_f';
elseif sell == 5
    spring.nu = X1;
    var1_name = '\nu';
end

if sel2 == 1
    spring.d_i = X2;
    var2_name = 'd_i';
elseif sel2 == 2
    spring.d_w = X2;
    var2_name = 'd_w';
elseif sel2 == 3
    spring.L_free = X2;
    var2_name = 'L_f';
elseif sel2 == 4
    spring.N_t = X2;
    var2_name = 'N_t';
elseif sel2 == 5
    spring.nu = X2;
    var2_name = '\nu';
end

% convert
spring = Convert_Build_Params_vectorize(spring);

L_hat = 0.025;
delta = spring.L_free - L_hat;

theta = compute_theta_vectorize(spring,delta);

% plot
fig = figure();
fig.Position = [100 100 1100 500];
annotation('textbox', [0 0.9 1 0.1], ...
    'String', ['$\delta=~L_f-\hat{L}, \hat{L}=~$' num2str(L_hat*1e3) 'mm'], ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center',...
    'interpreter','latex',...
    'fontsize',20)
subplot(121);hold on;
f_surf = surf(X1*1e3,X2*1e3,theta);
% colormap(flipud(ho));
set(f_surf,'linestyle','-')
xlabel(['$' var1_name '~$(mm)'],'interpreter','latex','fontsize',20)
ylabel(['$' var2_name '~$(mm)'],'interpreter','latex','fontsize',20)
zlabel('$\theta~(^{\circ})$','interpreter','latex','fontsize',20)
view([-1 -1 3])
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
    'FontSize'    , 18        , ...
    'LineWidth'   , 1         );
axis tight
subplot(122);hold on;
f_cont = contourf(X1*1e3,X2*1e3,theta,20);
f_color = colorbar;
set(f_color,'ticklabelinterpreter','latex')
xlabel(['$' var1_name '~$(mm)'],'interpreter','latex','fontsize',20)
ylabel(['$' var2_name '~$(mm)'],'interpreter','latex','fontsize',20)
axis tight
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
    'FontSize'    , 18        , ...
    'LineWidth'   , 1         );
set(gcf,'PaperPositionMode','auto')
print(['figures/surface_contour_d_i_vs_d_w_' num2str(e*100) 'uncertainty'],'-dpng','-r0','-painters')
savefig(['figures/surface_contour_L_hat_' var1_name '_vs_' var2_name '_' num2str(e*100) 'uncertainty.fig'])
