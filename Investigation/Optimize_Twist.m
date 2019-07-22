function [xfinal] = Optimize_Twist(Fhat, Lhat)
% SAMSI IMSM Team Twistigate 2019
%REMINDER TODO!- Change f1 and f2 so that we take H_0=L_free-d_w 
% Takes force, Lhat, Poisson ratio and G and optimizes to reduce twist
d_i_min=0.010;
d_i_max=0.050;
d_w_min=0.001;
nu=0.30;
G=79e9;
L_free_max=0.1;
syms L_free theta d_i d_w N_t n_1 l_w
x = [N_t;d_i;d_w;L_free]; % column vector of symbolic variables
f1(N_t,d_i,d_w,L_free) = 2*180*(N_t - ((L_free^2 + 4*N_t^2*pi^2*(d_i/2 + d_w/2)^2)*(nu + 1)*(d_i/2 + d_w/2)*(L_free^2 - Lhat^2 + 4*N_t^2*pi^2*(d_i/2 + d_w/2)^2))/(2*pi*((d_i/2 + d_w/2)^2 + L_free^2/(4*N_t^2*pi^2))*((nu + 1)*(L_free^2 - Lhat^2 + 4*N_t^2*pi^2*(d_i/2 + d_w/2)^2)^(3/2) - Lhat*(L_free^2 + 4*N_t^2*pi^2*(d_i/2 + d_w/2)^2)^(1/2)*(L_free - Lhat))));
n1(N_t,d_i,d_w,L_free) =((L_free^2 + 4*N_t^2*pi^2*(d_i/2 + d_w/2)^2)*(nu + 1)*(d_i/2 + d_w/2)*(L_free^2 - Lhat^2 + 4*N_t^2*pi^2*(d_i/2 + d_w/2)^2))/(2*pi*((d_i/2 + d_w/2)^2 + L_free^2/(4*N_t^2*pi^2))*((nu + 1)*(L_free^2 - Lhat^2 + 4*N_t^2*pi^2*(d_i/2 + d_w/2)^2)^(3/2) - Lhat*(L_free^2 + 4*N_t^2*pi^2*(d_i/2 + d_w/2)^2)^(1/2)*(L_free - Lhat)));
l_w(N_t,d_i,d_w,L_free) = ((L_free - d_w)^2 + 4*N_t^2*pi^2*(d_i/2 + d_w/2)^2);
Fcalc(N_t,d_i,d_w,L_free) = ((G*d_w^4*pi^2*n1^2)/(8*(l_w^2-Lhat^2)));
f2(N_t,d_i,d_w,L_free) = (Fhat - Fcalc)^2;
%f = 2*pi*(x1 - ((x2/2 + x3/2)*((286138806900821545*x1^2)/70368744177664 + 103*x4^2)*((2778046668940015*x1^2)/70368744177664 + x4^2 - 1/10000))/(200*pi*((70368744177664*x4^2)/(2778046668940015*x1^2) + (x2/2 + x3/2)^2)*((103*((2778046668940015*x1^2)/70368744177664 + x4^2 - 1/10000)^(3/2))/100 - (x4/100 - 1/10000)*((2778046668940015*x1^2)/70368744177664 + x4^2)^(1/2)))) + ((52980395557970032*x3^4*(x2/2 + x3/2)^2*((2778046668940015*x1^2)/70368744177664 + x4^2)^2*(x4 - 1/100)*((2778046668940015*x1^2)/70368744177664 + x4^2 - 1/10000)^(1/2))/(6782340500341833*((70368744177664*x4^2)/(2778046668940015*x1^2) + (x2/2 + x3/2)^2)^2*((103*((2778046668940015*x1^2)/70368744177664 + x4^2 - 1/10000)^(3/2))/100 - (x4/100 - 1/10000)*((2778046668940015*x1^2)/70368744177664 + x4^2)^(1/2))^2) - 5)^2
f = f2;%(0.0000001*f1)+(100000*f2);
c1 = -N_t;% + N_t_min;
c2 = -d_i + d_i_min;
c3 = L_free - L_free_max;
c4 = (N_t+1)*d_w - Lhat;
c5 = Lhat - L_free;
c6 = d_i - d_i_max;
c7 = -d_w + d_w_min;
c8 = (L_free/(pi*(d_i+d_w)*N_t)) - 0.364;

c = [c1 c2 c3 c4 c5 c6 c7 c8];
gradc = jacobian(c,x).'; % transpose to put in correct form
% constraint = matlabFunction(c,[],gradc,[],'vars',{x});
% hessc1 = jacobian(gradc(:,1),x); % constraint = first c column
% hessc2 = jacobian(gradc(:,2),x);
% 
% hessc1h = matlabFunction(hessc1,'vars',{x});
% hessc2h = matlabFunction(hessc2,'vars',{x});

options = optimoptions('fmincon','Algorithm','interior-point',...
    'Display','final');

% fh3 = objective without gradient or Hessian
fh3 = matlabFunction(f,'vars',{x});
% constraint without gradient:
constraint = matlabFunction(c,[],'vars',{x});
[xfinal,fval,exitflag,output2] = fmincon(fh3,[7;0.024;0.001;0.1],...
    [],[],[],[],[],[],constraint,options);
thetafinal=double(f1(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
fconstfinal=double(f2(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
ffinal=double(Fcalc(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
l_wfinal=double(l_w(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
n1final=double(n1(xfinal(1),xfinal(2),xfinal(3),xfinal(4)))
fval;
assume([N_t,d_i,d_w,L_free],'clear')
end

