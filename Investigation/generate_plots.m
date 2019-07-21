clear

load_path
spring = nominal_spring();
%Here we plot theta(deflection) and use several numbers of coils
n_coils = [4.5, 7, 8.5, 10.5, 13.5, 15.5];
for j = 1:length(n_coils)
    spring.N_t = n_coils(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    delta = .0001:1e-4:.085;  % deflection through 85%
    for i = 1:length(delta)
    theta(i) = compute_theta(Conversion_Output, delta(i));
    end
    plot(delta/1000, theta, 'linewidth', 2); hold on 
    l{j} = strcat('n_0 = ', num2str(n_coils(j)));
end

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('delfection (mm)')
ylabel('\theta')
legend(l,'location', 'best')

%% Now plot theta(inner diameter) - Mike
clear

load_path
spring = nominal_spring();
%Here we plot theta(deflection) and use several numbers of coils
n_coils = 5:1:9;
for j = 1:length(n_coils)
    spring.N_t = n_coils(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    inner_diam = .01:1e-4:.06;  % inner diameter through 50 mm
    delta = .5*Conversion_Output.delta_max;  % fix at half of full deflection
    clear theta
    for i = 1:length(inner_diam)
        spring.d_i = inner_diam(i); % iterate over different d_i
        Conversion_Output = Convert_Build_Params(spring);
        theta(i) = compute_theta(Conversion_Output, delta);
        %disp(num2str(Conversion_Output.R_0))
    end
    plot(inner_diam, theta, 'linewidth', 2); hold on 
    l{j} = strcat('N_t = ', num2str(n_coils(j)));
end

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('Inner Diameter (m)')
ylabel(['\theta ','(\circ)'])
legend(l,'location', 'best')
title(['Fixing ','$$\delta = \frac{\delta_{max}}{2}$$'],...
    'interpreter','latex')

%% plot F(delta)
clear

load_path
spring = nominal_spring();
%Here we plot theta(deflection) and use several numbers of coils
n_coils = 5:1:9;
for j = 1:length(n_coils)
    spring.N_t = n_coils(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    delta = 0:1e-4:.85*Conversion_Output.delta_max;
    clear F
    for i = 1:length(delta)
        rate(i) = Compute_k(Conversion_Output, delta(i));
        F(i) = rate(i)*delta(i);

    end
    plot(delta/1000, F, 'linewidth', 2); hold on 
    l{j} = strcat('N_t = ', num2str(n_coils(j)));
end

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('Deflection (m)')
ylabel(['Force (N)'])
legend(l,'location', 'best')
title(['Fixing ','$$\delta = 0 ~to~ .85\delta_{max}$$'],...
    'interpreter','latex')


