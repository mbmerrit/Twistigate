load_path;
spring = nominal_spring();
spring = Convert_Build_Params(spring);
a=compute_theta(spring, delta);

Lhat = 0.025;
spring.N_t = 8.1053;
spring.d_i = 0.0652;
spring.d_w = 0.0017;
spring.L_free = 0.0613;
spring.end_condition = 'open';
spring = Convert_Build_Params(spring);

delta = spring.L_free-Lhat;
a=compute_theta(spring, delta)