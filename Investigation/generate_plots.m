clear

%Here we plot theta(deflection) and use several numbers of coils
n_coils = [4.5, 7, 8.5, 10.5, 13.5, 15.5];
for j = 1:length(n_coils)
    [Conversion_Output] = Convert_Build_Params(.001, .024, 'open', n_coils(j), .1);
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

%% Now plot theta()
