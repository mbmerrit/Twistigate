% Equations from the 2015 paper, we want to use these quantities at some
% point

k = (G/8/N_a) * (d_w^4/(d_i + d_w)^3);

C = d_i/d_w + 1;

F_open = (L_free - L_open)*k;

g = (L_hard - L_solid)/(N_t - 1);

lambda = L_free/(d_i + d_w);

tau = G*(L_free - L_hard)/(4*pi*N_a) * ((d_w*(4*d_i^2 + 9.46*d_i*d_w + 3*d_w^2))...
    / d_i*(d_i + d_w)^3);

d_exp = d_w + sqrt((d_i + d_w)^2 + (p^2 - d_w)/pi^2);

