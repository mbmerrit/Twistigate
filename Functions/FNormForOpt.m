function [FNorm spring] = FNormForOpt(x, Fhat, Lhat)
%load_path
spring=nominal_spring();
spring.N_t= x(1);
spring.d_i= x(2);
spring.d_w= x(3);
spring.L_free= x(4);
spring=Convert_Build_Params(spring);
spring=spring_metrics(spring);

FNorm=(spring.F_1-Fhat)^2;
