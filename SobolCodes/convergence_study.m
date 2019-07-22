tic

N_pts = floor(logspace(1,log10(N),10));
Nlen = length(N_pts);
TotalSob_theta = zeros(Nlen,ndim);
SingleSob_theta = zeros(Nlen,ndim);

for k = 1:Nlen
    QA = qA(1:N_pts(k));
    QB = qB(1:N_pts(k));
    QC = qC(1:N_pts(k),:);
    [TotalSob_theta(k,:) SingleSob_theta(k,:)] = get_sobol_indices(QA,QB,QC);
end
toc
%% This is just for first order Indices
figure(4)
semilogx(N_pts,SingleSob_theta,'-o')
set(gca, 'fontsize', 20); xlabel('N')
xtik = {'d_i','d_w','L_f','N_t','\nu','\delta'};
title('Convergence of First Order Sobol Indices by N')
legend(xtik,'location','best')
%% This is just for Total Indices
figure(2)
semilogx(N_pts,TotalSob_theta(:,1),'-o',N_pts, TotalSob_theta(:,6),'-o')
set(gca, 'fontsize', 20); xlabel('N')
xtik = {'d_i','\delta'};
title('Convergence of Total Sobol Indices by N')
legend(xtik,'location','best')

figure(3)
semilogx(N_pts,TotalSob_theta(:,2:5),'-o')
set(gca, 'fontsize', 20); xlabel('N')
xtik = {'d_w','L_f','N_t','\nu'};
title('Convergence of Total Sobol Indices by N')
legend(xtik,'location','best')

figure(4)
semilogx(N_pts,TotalSob_theta,'-o')
set(gca, 'fontsize', 20); xlabel('N')
xtik = {'d_i','d_w','L_f','N_t','\nu','\delta'};
title('Convergence of Total Sobol Indices by N')
legend(xtik,'location','best')

%% Now let's look at 2nd order indices, most should be about 0
% Indices are organized: S23, S13, S12

[Sec_rre] = get_secondorder_indices(qA_rre, qB_rre, qC_rre);
[Sec_ssa] = get_secondorder_indices(qA_ssa, qB_ssa, qC_ssa);
[Sec_cle] = get_secondorder_indices(qA_cle, qB_cle, qC_cle);

% Try this backdoor approach
T = T_rre; S = S_rre;
SecondSob_rre = .5*[T(3)-S(3)-T(2)+S(2)+T(1)-S(1), T(1)-S(1)-T(3)+S(3)+T(2)-S(2),...
    T(2)-S(2)-T(1)+S(1)+T(3)-S(3)];

T = mean(T_ssa); S = mean(S_ssa);
SecondSob_ssa = .5*[T(3)-S(3)-T(2)+S(2)+T(1)-S(1), T(1)-S(1)-T(3)+S(3)+T(2)-S(2),...
    T(2)-S(2)-T(1)+S(1)+T(3)-S(3)];

T = mean(T_cle); S = mean(S_cle);
SecondSob_cle = .5*[T(3)-S(3)-T(2)+S(2)+T(1)-S(1), T(1)-S(1)-T(3)+S(3)+T(2)-S(2),...
    T(2)-S(2)-T(1)+S(1)+T(3)-S(3)];


figure; bar([Sec_rre; mean(Sec_ssa); mean(Sec_cle)])
param_labels = {'RRE','SSA','CLE'}; 
set(gca,'fontsize', 20, 'xticklabels', param_labels);
title('RRE - Second Order Sobol Indices')
legend('S_{2,3}','S_{1,3}','S_{1,2}')

%% Third order indices - easier to compute, should be close to 0
[Third_rre] = get_thirdorder_indices(qA_rre, qB_rre, qC_rre);
[Third_ssa] = get_thirdorder_indices(qA_ssa, qB_ssa, qC_ssa);
[Third_cle] = get_thirdorder_indices(qA_cle, qB_cle, qC_cle);

bar([Third_rre, mean(Third_ssa), mean(Third_cle)])
param_labels = {'RRE','SSA','CLE'}; 
set(gca,'fontsize', 20, 'xticklabels', param_labels);
title('Third Order Sobol Indices')

%% Now test, do all indices for each model sum to 1? Backdoor way
disp(['RRE: ',num2str(sum([S_rre, SecondSob_rre, Third_rre]))])
disp(['SSA: ',num2str(sum([mean(S_ssa), SecondSob_ssa, mean(Third_ssa)]))])
disp(['CLE: ',num2str(sum([mean(S_cle), SecondSob_cle, mean(Third_cle)]))])


%% Same, but with the actual second order estimator 
disp(['RRE: ',num2str(sum([S_rre, Sec_rre, Third_rre]))])
disp(['SSA: ',num2str(sum([mean(S_ssa), mean(Sec_ssa), mean(Third_ssa)]))])
disp(['CLE: ',num2str(sum([mean(S_cle), mean(Sec_cle), mean(Third_cle)]))])

% Basically, I don't have a good estimator for the second order indices so
% I used this backdoor approach from computed quantities and it makes the
% model happy, so...
% This model uses S123 = 0, but that can be fixed by subtracting S123 from
% each second order index, but they are all almost 0


