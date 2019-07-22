function n_1 = compute_n1_vectorize(spring, delta)
% Unpack the input:
R_0 = spring.R_0;
H_0 = spring.H_0;
H_1 = H_0 - delta;
n_0 = spring.n_0;
nu = spring.nu;
l_w = spring.l_w;

n_1 = (l_w.^2 - H_1.^2)./(2*pi).*R_0./(R_0.^2 + (H_0./(2*pi*n_0)).^2).*l_w.^2.*(1+nu)./((1+nu).*(l_w.^2 - H_1.^2).^(3/2) - (delta).*H_1.*l_w);
end