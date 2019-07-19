%%
clear

delta = linspace(0,0.1,100);  % deflection through 85%
theta=zeros(size(delta)); %initialize_theta

load_path
%%
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
n_coils = [4.5, 7, 8.5, 10.5, 13.5, 15.5];
l2=strings(size(n_coils));

for j = 1:length(n_coils)
    spring.N_t = n_coils(j);
    [Conversion_Output] = Convert_Build_Params(spring);
    for i = 1:length(delta)
    theta(i) = compute_theta(Conversion_Output, delta(i));
    end
    plot(delta, theta, 'linewidth', 2); hold on 
    l2{j} = strcat('N_T = ', num2str(n_coils(j)));
end

set(gca,'fontsize', 20)
axis tight; grid on
xlabel('deflection (mm)')
ylabel('\theta')
legend(l2,'location', 'best')
title('Angle of twist vs deflection for nominal open ground spring, varied # of coils')

