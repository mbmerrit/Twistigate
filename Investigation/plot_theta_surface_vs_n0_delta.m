clear;clc;close all

load_path

% nominal spring variables
possible_end_conditions = {'open','open_ground','closed_ground'};

figure();hold on;
for j = 1:3;
    end_condition = possible_end_conditions{j};
    N_t = 7; % number of total coils
    d_i = 0.024; % inner diameter, m
    d_w = 0.001; % wire diameter, m
    L_free = 0.100; % free length, m
    delta_factor = 0.25;
    
    switch j
        case 1
            mymarker{j} = '.';
        case 2
            mymarker{j} = 'o';
        case 3
            mymarker{j} = '^';
    end
    
    % variable
    N_t_range = 4:1:30;
    
    for i = 1:length(N_t_range)
        
        spring.d_w = d_w;
        spring.d_i = d_i;
        spring.N_t = N_t_range(i);
        spring.end_condition = end_condition;
        spring.L_free = L_free;
    
        % conversion
        [Conversion_Output] = ...
            Convert_Build_Params...
            (spring);
        
        n_0 = Conversion_Output.n_0; % # of active coil
        l_w = Conversion_Output.l_w; % length of active wire
        H_0 = Conversion_Output.H_0;
        H_0_save(i) = H_0;
        D_0 = Conversion_Output.D_0;
        R_0 = Conversion_Output.R_0;
        L_solid = Conversion_Output.L_solid;
        nu = Conversion_Output.nu;
        delta = 0.08; % fixed delta
%         delta = (L_free - L_solid)*delta_factor;
        delta_save(i) = delta;
        H_1 = H_0 - delta;
        
        save_l_w(i) = n_0;
        
        % compute twist angle
        theta(j,i) = compute_theta(Conversion_Output, delta);
    end
    
    % figure
    f{j}=plot(N_t_range, theta(j,:),mymarker{j},'linewidth',2,'markersize',8);
end

legend([f{1} f{2} f{3}],'Open','Open ground','Closed ground');legend boxoff
xlabel('$n_T$', 'FontSize', 20 , 'interpreter', 'latex')
ylabel('$\theta~(^{\circ})$', 'FontSize', 20 , 'interpreter', 'latex')
% title(['$\delta_{' num2str(delta_factor) '}= (L_f - L_s)\times ' num2str(delta_factor) '$'],'interpreter','latex')
title(['$\delta=' num2str(delta*1e3) '$~(mm)'],'interpreter','latex')
set(legend,'location','northeast','fontsize',20,'interpreter','latex')
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
    'Xtick'       , [5 10 15 20 25 30 35 40] , ...
    'XLIm'        , [4 30] ,...
    'LineWidth'   , 1         );
set(gcf,'PaperPositionMode','auto')
% set(gca,'YTickLabel'  , num2str(transpose(get(gca, 'YTick')), '%.0f'))
print(['figures/theta_vs_n_T_del_' num2str(delta*100)],'-deps','-r0','-painters')
print(['figures/theta_vs_n_T_del_' num2str(delta*100)],'-dpng','-r0','-painters')
savefig(['figures/theta_vs_n_T_del_' num2str(delta*100) '.fig'])


