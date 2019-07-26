Lhat = 0.025;
load_path;
spring = nominal_spring();
 spring = Convert_Build_Params(spring);
 delta = spring.L_free-Lhat;
 a=compute_theta(spring, delta)

Lhat = 0.025;
spring.N_t = 12.4766;
spring.d_i = 0.0390;
spring.d_w = 0.0013;
spring.L_free = 0.0611;
spring.end_condition = 'open';
spring = Convert_Build_Params(spring);

delta = spring.L_free-Lhat;
k=Compute_k(spring,delta);

%k*delta;
%Optimize_Twist_struct(6.09,0.025)
