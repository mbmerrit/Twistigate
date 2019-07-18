clear

% Some nominal parameter values
H0 = .076;
x = 0:.0001:.85*H0;
H1 = H0 - x;
R0 = .01;
n0 = 15.5;
D = 2*R0;
L = sqrt((pi*D*n0)^2 + (H0)^2);
nu = .3;

for i = 1:length(x)
    D1n1(i) = k(R0, H0, H1(i), n0, x(i), L, nu);
end

plot(x/1000, 1./D1n1, 'linewidth', 2)
set(gca,'fontsize', 20)
xlabel('x (mm)'); ylabel('Scaled Rate - k')
axis tight
grid on

function D1n1 = k(R0, H0, H1, n0, x, L, nu)
A = (R0^2 + (H0/(2*pi*n0))^2);
B = ((L^2 - H1^2)/L^2) - (x*(H0 - x))/(L*(1 + nu)*sqrt(L^2 + H1^2));
parens = (A * B)^2;
D1n1 = 4*sqrt(L^2 - H1^2)/pi * parens;
end