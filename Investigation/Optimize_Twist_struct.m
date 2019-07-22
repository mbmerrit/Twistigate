function [xfinal] = Optimize_Twist_struct(Fhat, Lhat)
% SAMSI IMSM Team Twistigate 2019
%REMINDER TODO!- Change f1 and f2 so that we take H_0=L_free-d_w 
% Takes force, Lhat, Poisson ratio and G and optimizes to reduce twist
d_i_min=0.010;
d_i_max=0.050;
d_w_min=0.001;
nu=0.30;
G=79e9;
L_free_max=0.1;

syms N_t d_i d_w L_free
x = [N_t;d_i;d_w;L_free]; 
F_hat = Fhat; L_hat = Lhat;% Assign parameter values
f = @(x)ThetaForOpt(x, F_hat, L_hat);
% fh3 = objective without gradient or Hessian
%fh3 = matlabFunction(ThetaForOpt,'vars',{x});

c1 = -N_t;% + N_t_min;
c2 = -d_i + d_i_min;
c3 = L_free - L_free_max;
c4 = (N_t+1)*d_w - L_hat;
c5 = L_hat - L_free;
c6 = d_i - d_i_max;
c7 = -d_w + d_w_min;
c8 = (L_free/(pi*(d_i+d_w)*N_t)) - 0.364;

c = [c1 c2 c3 c4 c5 c6 c7 c8];
%gradc = jacobian(c,x).'; % transpose to put in correct form
% constraint = matlabFunction(c,[],gradc,[],'vars',{x});
% hessc1 = jacobian(gradc(:,1),x); % constraint = first c column
% hessc2 = jacobian(gradc(:,2),x);
% 
% hessc1h = matlabFunction(hessc1,'vars',{x});
% hessc2h = matlabFunction(hessc2,'vars',{x});

options = optimoptions('fmincon','Algorithm','interior-point',...
    'Display','final');
% constraint without gradient:
constraint = matlabFunction(c,[],'vars',{x});
[xfinal,fval,exitflag,output2] = fmincon(f,[7;0.024;0.001;0.1],...
    [],[],[],[],[],[],constraint,options);
% thetafinal=double(f1(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
% fconstfinal=double(f2(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
% ffinal=double(Fcalc(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
% l_wfinal=double(l_w(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
% n1final=double(n1(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
% fval;
% assume([N_t,d_i,d_w,L_free],'clear')
end

