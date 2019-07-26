function [spring] = Optimize_Twist_F_Constrained(Fhat, Lhat,init_spring_params, beta_1,beta_2)
% SAMSI IMSM Team Twistigate 2019

% All inputs in SI units
% Takes force, Lhat, init_spring_params = [N_t_init;d_i_init; d_w_init;
% L_free_init], weight for theta and weight for force constraint and 
% optimizes to reduce twist, while keeping force constrained to Fhat (N) at
% the compressed height of Lhat (m)

if isempty(beta_1)
    beta_1 = 1e-4;
end

if isempty(beta_2)
    beta_2 = 1e4;
end

if isempty(init_spring_params)
    init_spring_params=[7;0.024;0.001;0.1];
end

N_t_min = 3;
%N_t_max=7.001;

d_i_min=0.001;
%d_i_min=0.0235;
%d_i_max=0.0245;

d_w_min = 0.001;
%d_w_max = 0.005;

L_free_min = 0.03; %0;
L_free_max = 1; %100;

syms N_t d_i d_w L_free
x = [N_t;d_i;d_w;L_free]; 

F_hat = Fhat; L_hat = Lhat;% Assign parameter values
f=@(x)((beta_1*ThetaForOpt(x, F_hat, L_hat))+(beta_2*FNormForOpt(x, F_hat, L_hat)));

%N_t design constraints
c1 = -N_t + N_t_min; %Min constraint on N_t
%c11 = N_t - N_t_max; %Max constraint on N_t

%d_i design constraints
c2 = -d_i + d_i_min; %Min constraint on d_i
%c6 = d_i - d_i_max; %Max constraint on d_i

%d_w design constraints
c7 = -d_w + d_w_min; %Min constraint on d_w
%c9 = d_w - d_w_max; %Max constraint on d_w

%L_free design constraints
c3 = L_free - L_free_max; %%Max constraint on L_free
c13 = L_free_min - L_free; %Min constraint on L_free

%Physical constraint (10/9)L_solid < L_hat < L_free
c4 = (N_t+1)*d_w - (0.9*L_hat); %L_solid<0.9 L_hat
c5 = L_hat - L_free; %L_hat<L_free

%Model assumption/physical constraint- pitch angle<20deg.
c8 = (L_free/(pi*(d_i+d_w)*N_t)) - 0.364; %tan(pitch angle)<tan(20deg)

c=[c1 c2 c3 c4 c5 c7 c8 c13];

options = optimoptions('fmincon','Algorithm','interior-point',...
    'Display','iter');
constraint = matlabFunction(1e2*c,[],'vars',{x});
[xfinal,fval] = fmincon(f,init_spring_params,...
    [],[],[],[],[],[],constraint,options);
spring=nominal_spring();
spring.N_t = xfinal(1);
spring.d_i = xfinal(2);
spring.d_w = xfinal(3);
spring.L_free = xfinal(4);
spring = spring_metrics(spring);
%theta_opt = spring.theta;
end