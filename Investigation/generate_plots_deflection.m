%%
clear
n_linsp=1000;
delta = linspace(0,0.1,n_linsp);  % deflection through 0.1m=100 mm%
theta=zeros(n_linsp, n_linsp); %initialize_theta
n_coils = linspace(5,9,n_linsp);  % deflection through 0.1m=100 mm%

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

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('n coils')
ylabel('deflection (mm)')
zlabel('\theta (\circ)')
legend(l2,'location', 'best')
title('Angle of twist vs deflection for nominal open ground spring, varied # of coils')

