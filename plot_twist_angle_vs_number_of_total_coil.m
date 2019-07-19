clear, clc, close all

% nominal spring variables
possible_end_conditions = {'open','closed','closed_ground'};
end_condition = possible_end_conditions{1};
N_t = 7; % number of total coils
d_i = 0.024; % inner diameter, m
d_w = 0.001; % wire diameter, m
L_free = 0.100; % free length, m
L_solid = 0.070; % solid height, m

% variable
N_t_range = linspace(1,100,100);

for i = 1:length(N_t_range)
% conversion
[Conversion_Output] = ...
  Convert_Build_Params(d_w, N_t_range(i), end_condition, N_t, L_free);

n_0 = Conversion_Output.n_0; % # of active coil
l_w = Conversion_Output.l_w; % length of active wire
H_0 = Conversion_Output.H_0;
D_0 = Conversion_Output.D_0;
R_0 = Conversion_Output.R_0;
gamma_0 = Conversion_Output.gamma_0;
nu = 0.3;
delta = (L_free - L_solid)*0.85;
H_1 = H_0 - delta;

% compute twist angle
theta(i) = compute_theta(n_0, l_w, H_0, H_1, R_0, nu);
end

% figure
figure();hold on;
plot(N_t_range, theta*180/pi,'r.','linewidth',2);
xlabel('\#~of~$N_t$', 'FontSize', 20 , 'interpreter', 'latex')
ylabel('$\theta~(^{\circ})$', 'FontSize', 20 , 'interpreter', 'latex')
set(legend,'location','northwest','fontsize',20,'interpreter','latex')
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
print(['figures/theta_vs_N_t'],'-depsc','-r0','-painters')
print(['figures/theta_vs_N_t'],'-dpng','-r0','-painters')
   
            
