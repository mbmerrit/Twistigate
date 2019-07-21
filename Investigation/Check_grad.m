nu=0.030;
Lhat=0.01;
Fhat=5;
syms L_free theta d_i d_w N_t
x = [N_t;d_i;d_w;L_free]; % column vector of symbolic variables
f(N_t,d_i,d_w,L_free) = 2*pi*(N_t - (103*(L_free^2 + 4*pi^2*N_t^2)*(d_i/2 + d_w/2)*(L_free^2 - Lhat^2 + 4*pi^2*N_t^2))/(200*pi*((d_i/2 + d_w/2)^2 + L_free^2/(4*N_t^2*pi^2))*((103*(L_free^2 - Lhat^2 + 4*pi^2*N_t^2)^(3/2))/100 - Lhat*(L_free - Lhat)*(L_free^2 + 4*pi^2*N_t^2)^(1/2)))) + (Fhat - (27125962525680656499*d_w^4*(L_free - Lhat)*(L_free^2 + 4*pi^2*N_t^2)^2*(d_i/2 + d_w/2)^2*(L_free^2 - Lhat^2 + 4*pi^2*N_t^2)^(1/2))/(351843720888320000*pi^2*((d_i/2 + d_w/2)^2 + L_free^2/(4*N_t^2*pi^2))^2*((103*(L_free^2 - Lhat^2 + 4*N_t^2*pi^2)^(3/2))/100 - Lhat*(L_free - Lhat)*(L_free^2 + 4*N_t^2*pi^2)^(1/2))^2))^2;
%f = 2*pi*(x1 - ((x2/2 + x3/2)*((286138806900821545*x1^2)/70368744177664 + 103*x4^2)*((2778046668940015*x1^2)/70368744177664 + x4^2 - 1/10000))/(200*pi*((70368744177664*x4^2)/(2778046668940015*x1^2) + (x2/2 + x3/2)^2)*((103*((2778046668940015*x1^2)/70368744177664 + x4^2 - 1/10000)^(3/2))/100 - (x4/100 - 1/10000)*((2778046668940015*x1^2)/70368744177664 + x4^2)^(1/2)))) + ((52980395557970032*x3^4*(x2/2 + x3/2)^2*((2778046668940015*x1^2)/70368744177664 + x4^2)^2*(x4 - 1/100)*((2778046668940015*x1^2)/70368744177664 + x4^2 - 1/10000)^(1/2))/(6782340500341833*((70368744177664*x4^2)/(2778046668940015*x1^2) + (x2/2 + x3/2)^2)^2*((103*((2778046668940015*x1^2)/70368744177664 + x4^2 - 1/10000)^(3/2))/100 - (x4/100 - 1/10000)*((2778046668940015*x1^2)/70368744177664 + x4^2)^(1/2))^2) - 5)^2
c1 = -N_t;
c2 = -d_i;
c3 = -d_w;
c4 = (N_t+1)*d_w - Lhat;
c = [c1 c2 c3 c4];
gradc = jacobian(c,x).'; % transpose to put in correct form
constraint = matlabFunction(c,[],gradc,[],'vars',{x});
hessc1 = jacobian(gradc(:,1),x); % constraint = first c column
hessc2 = jacobian(gradc(:,2),x);

hessc1h = matlabFunction(hessc1,'vars',{x});
hessc2h = matlabFunction(hessc2,'vars',{x});

options = optimoptions('fmincon','Algorithm','interior-point',...
    'Display','final');
% fh3 = objective without gradient or Hessian
fh3 = matlabFunction(f,'vars',{x});
% constraint without gradient:
constraint = matlabFunction(c,[],'vars',{x});
[xfinal,fval,exitflag,output2] = fmincon(fh3,[3;2;1;2],...
    [],[],[],[],[],[],constraint,options)
assume([N_t,d_i,d_w,L_free],'clear')                