%%
syms l_w R_0 H_0 n_0 H_1 L_free Lhat n_1 theta
n_1 = ((l_w^2 - H_1^2) / (2*pi)) * (R_0/ (R_0^2 + (H_0/(2*pi*n_0))^2)) * ((l_w^2 ...
    * (1.30)) / ((1.30)*(l_w^2 - H_1^2)^(3/2) - (L_free-Lhat)*H_1*l_w));

partn1partn0 = diff(n_1,n_0)
partn1partlw = diff(n_1,l_w)
partn1partH1 = diff(n_1,H_1)
totaln1Nt=(partn1partn0+partn1partlw*(4*pi^2*n_0*R_0^2/l_w))
l_w=1000;
R_0=10;
H_0=100;
n_0=10;
H_1=90;
L_free=100;
Lhat=90;
n_1=9;

%%
syms x y z w

x=2* y;
z=4*w;
diff(x,y)