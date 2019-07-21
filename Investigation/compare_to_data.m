% Compare our predictions to the data reported in the Michalczyk paper

clear, clc, close all

load_path
spring = nominal_spring();

% given data
d_w   = 0.004;
L_f   = [275, 260, 275, 275, 275]/1000;
n_o   = [9.5, 9.5, 9.5, 9.5, 9.5];
pitch = 30/1000;
theta = [10, 12, 13.5, 20, 27.5];
d_i   = ([90,80,70,60,50])/1000-d_w;
delta = 180/1000;

% keeping free length as measured
for i = 1:5
    spring.d_w = d_w;
    spring.L_free = L_f(i);
    spring.N_t = 8.5;
    spring.d_i = d_i(i);

    spring = Convert_Build_Params(spring);
    
    theta_n_85(i) = compute_theta(spring, delta);
end

% keeping free length as measured
for i = 1:5
    spring.d_w = d_w;
    spring.L_free = L_f(i);
    spring.N_t = 9.5;
    spring.d_i = d_i(i);

    spring = Convert_Build_Params(spring);
    
    theta_n_95(i) = compute_theta(spring, delta);
end

% keeping free length as measured
for i = 1:5
    spring.d_w = d_w;
    spring.L_free = L_f(i);
    spring.N_t = 10.5;
    spring.d_i = d_i(i);

    spring = Convert_Build_Params(spring);
    
    theta_n_105(i) = compute_theta(spring, delta);
end

hold on
plot(d_i*1000, theta, '-o')
plot(d_i*1000, theta_n_85, '-o')
plot(d_i*1000, theta_n_95, '-o')
plot(d_i*1000, theta_n_105, '-o')

xlabel('d_i')
ylabel('\theta (\circ)')
legend('Michalczyk Data','n_0 = 8.5','n_0 = 9.5','n_0 = 10.5')
