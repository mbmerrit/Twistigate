syms l_w H_1 R_0 H_0 n_0 nu L_free Lhat Fhat G d_i d_w N_t n_1 Fconst

l_w=sqrt(H_0^2+(2*pi*n_0*R_0)^2);
l_w(N_t,d_i, d_w, L_free)= subs(l_w,[R_0,H_0, n_0, H_1],[(0.5*(d_i+d_w)),(L_free-d_w),N_t,Lhat])

Fconst(l_w, R_0, H_0, n_0, nu, H_1, L_free, Lhat, Fhat, G)=(Fhat - ((G*d_w^4*pi^2*n_1^2)/(8*(l_w^2-H_1))))^2
Fconst=subs(Fconst,l_w,sqrt(H_0^2+(2*pi*n_0*R_0)^2));
%Fconst(N_t,d_i, d_w, L_free)=subs(Fconst,[R_0,H_0, n_0, H_1],[0.5*(d_i+d_w),L_free-d_w,N_t,Lhat]);
n_1(l_w, R_0, H_0, n_0, nu, H_1, L_free, Lhat, Fhat) = (l_w^2 - H_1^2) / (2*pi) * R_0 / (R_0^2 + (H_0/(2*pi*n_0))^2) * l_w^2 ...
    * (1+nu) / ((1+nu)*(l_w^2 - H_1^2)^(3/2) - (L_free-Lhat)*H_1*l_w);
theta(l_w, R_0, H_0, n_0, nu, H_1, L_free, Lhat, Fhat)=2*pi*(n_0-n_1);
theta=subs(theta,l_w,(sqrt(H_0^2+(2*pi*n_0*R_0)^2)));
theta(N_t,d_i, d_w, L_free)=subs(theta,[R_0,H_0, n_0, H_1],[(0.5*(d_i+d_w)),(L_free-d_w),N_t,Lhat])

