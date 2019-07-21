% Prototype of method for getting Lf

% make sure to add
%    L_hat as a spring parameter
%    F as a spring parameter
springs = <Get a bunch of springs>;

for i = 1:numel(springs)
    wrapper = @(Lf) objective_function(Lf, springs(i))
end

function val = objective_function(L_f, spring)
    spring.L_free = L_f;
    spring = Convert_Build_Params(spring);
    delta = spring.L_free - spring.L_hat;
    D_1 = 2 * compute_r1(spring, delta);
    n_1 = compute_n1(spring, delta);

    val = 8*spring.F*D_1^3*n_1 / (spring.G*spring.d_w^4) - (spring.L_free - spring.L_hat);
end