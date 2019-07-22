function spring = spring_metrics(spring)
    % function to compute all the metrics related to twisting

    if spring.L_hat == 0
        error('Spring must have an L_hat to compute')
    else
        spring.delta = spring.L_free - spring.L_hat;
    end

    % Update the spring params
    spring = Convert_Build_Params(spring);

    % check to make sure solid height is not too large
    if spring.L_solid > spring.L_hat
        warn('Spring is compressed past solid height')
    end

    spring.D_1      = 2*compute_r1(spring, spring.delta);
    spring.n_1      = compute_n1(spring, spring.delta);
    spring.theta    = compute_theta(spring, spring.delta);
    spring.F_1      = compute_f(spring, spring.delta);
    spring.k_1      = spring.F_1 / spring.delta;
    spring.k_0      = spring.G * spring.d_w^4 / (8 * spring.D_0^3 * spring.n_0);
    spring.buckling = spring.L_free / spring.D_0; 
    spring.C        = spring.D_0 / spring.d_w;
    
end