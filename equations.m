% Equations from the 2015 paper, we want to use these quantities at some
% point in our optimization section

k = (G/8/N_a) * (d_w^4/(d_i + d_w)^3);
% Above is the old k, the new k will just include D1
A = (R0^2 + (H0/(2*pi*n0))^2);
B = ((L^2 - H1^2)/L^2) - (x*(H0 - x))/(L*(1 + nu)*sqrt(L^2 + H1^2));
parens = (A * B)^2;
D1n1 = 4*sqrt(L^2 - H1^2)/pi * parens; %this is really (D1)^3(n1)
k = (G*d_w^4/8)/D1n1;

C = d_i/d_w + 1;

F_open = (L_free - L_open)*k;

g = (L_hard - L_solid)/(N_t - 1);

lambda = L_free/(d_i + d_w);

tau = G*(L_free - L_hard)/(4*pi*N_a) * ((d_w*(4*d_i^2 + 9.46*d_i*d_w + 3*d_w^2))...
    / d_i*(d_i + d_w)^3);

d_exp = d_w + sqrt((d_i + d_w)^2 + (p^2 - d_w)/pi^2);

phi = (2*pi*N_a8(d_i + d_w)^2)/(G*s*d_w^4) * % integrated portion




