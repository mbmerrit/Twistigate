clear, clc, close all

delta = .0001:1e-4:.085;  % deflection through 85%
theta=zeros(size(delta)); %initialize_theta

load_path

spring = nominal_spring();
%%
%Here we plot theta(deflection) and use different end conditions
endc={'open','closed_ground','open_ground'};
l={'open','closed ground', 'open ground'}; %legend
for j=1:length(endc)
    spring.end_condition=endc(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    for i = 1:length(delta)
    theta(i) = compute_theta(Conversion_Output, delta(i));
    end
    plot(delta*1000, theta, 'linewidth', 2); hold on
    %    l{j} = strcat(endc(j),'N_T = ');%, num2str(n_coils(j)));
end
set(gca,'fontsize', 20)
axis tight; grid on
xlabel('deflection (mm)')
ylabel('\theta')
legend(l,'location', 'best')
title('Angle of twist vs deflection for different end conditions')

%%
%Here we plot theta(deflection) and use several numbers of coils
%n_coils = [5,5.5,6,6.5,7, 7.5,8, 8.5,9];
l2=strings(size(n_coils));
spring.end_condition='open_ground';
    
for j = 1:length(n_coils)
    spring.N_t = n_coils(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    %theta=NaN(size(delta)); %initialize_theta
    for i = 1:n_linsp%Conversion_Output.delta_max*10000
    theta(i,j) = compute_theta(Conversion_Output, delta(i));
    end
%    plot(delta*1000, theta, 'linewidth', 2); hold on 
%    l2{j} = strcat('N_T = ', num2str(n_coils(j)));
end
surf(n_coils,delta,theta); hold on
%% Now plot theta(inner diameter) - Mike
clear

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('n coils')
ylabel('deflection (mm)')
zlabel('\theta (\circ)')
legend(l2,'location', 'best')
title('Angle of twist vs deflection for nominal open ground spring, varied # of coils')


load_path
spring = nominal_spring();
%Here we plot theta(deflection) and use several numbers of coils
n_coils = [4.5, 6.5, 8.5, 10.5, 13.5, 15.5];
for j = 1:length(n_coils)
    spring.N_t = n_coils(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    inner_diam = .0001:1e-4:.05;  % inner diameter through 50 mm
    delta = .5*Conversion_Output.delta_max;  % fix at half of full deflection
    clear theta
    for i = 1:length(inner_diam)
        spring.d_i = inner_diam(i); % iterate over different d_i
        Conversion_Output = Convert_Build_Params(spring);
        theta(i) = compute_theta(Conversion_Output, delta);
        %disp(num2str(Conversion_Output.R_0))
    end
    plot(inner_diam, theta, 'linewidth', 2); hold on 
    l{j} = strcat('n_0 = ', num2str(n_coils(j)));
end

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('Inner Diameter (mm)')
ylabel(['\theta ','(\circ)'])
legend(l,'location', 'best')
%%
%Here we plot theta(Lf) for fixed deflection and use several numbers of coils
clear
close all;
n_linsp=1000;
n_coils=linspace(5,9,5);
theta=NaN(n_linsp, 5); %initialize_theta
load_path
%n_coils=[5,6,7,8,9];
%n_coils = [5,6,7,8,9];
delta=0.075;
l2=strings(size(n_coils));
spring.end_condition='open_ground';
spring=nominal_spring();
spring=spring_metrics(spring());
L_free=linspace(0,0.2,n_linsp);
for j = 1:5
    spring.N_t = n_coils(j);
    spring=spring_metrics(spring);
    %[Conversion_Output] = Convert_Build_Params(spring);
    for i = 125:n_linsp%Conversion_Output.delta_max*10000
        spring.L_free=L_free(i);
        spring=spring_metrics(spring);
        theta(i,j)=spring.theta;
    end
    l2{j} = strcat('N_T = ', num2str(n_coils(j)));
end
    plot(L_free*1000, theta, 'linewidth', 2); hold on 
set(gca,'fontsize', 20)
axis tight; grid on
xlabel('L_{free} (mm)')
ylabel(['\theta ','(\circ)'])
legend(l2,'location', 'best')
