function F = compute_f(spring, delta)
    % computes the force applied by spring at a deflection
    F =  spring.G * spring.d_w^4 / (8 * spring.D_1^3 * spring.n_1) * delta;
end