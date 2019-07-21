function rate = Compute_k(spring, delta)
% Computes spring rate k where 'spring' is a struct
G = 76e9; % bulk/shear modulus
d_w = spring.d_w;
R_0 = spring.R_0;
H_0 = spring.H_0;
n_0 = spring.n_0;
l_w = spring.l_w;
nu = spring.nu;
H_1 = H_0 - delta;

B = ((l_w^2 - H_1^2)/l_w^2) - (delta*(H_0 - delta))/(l_w*(1 + nu)*sqrt(l_w^2 + H_1^2));
A = (R_0^2 + (H_0/(2*pi*n_0))^2);
parens = (A * B)^2;
D1cubedn1 = 4*sqrt(l_w^2 - H_1^2)/pi * parens;
rate = G*d_w^4/8*(1/D1cubedn1);
end