function display_output(spring)
% makes a pretty output
    fprintf('\n');
    fprintf('spring parameters\n')
    fprintf('\n');
    
    fprintf('\t End condition: \t%s\n', spring.end_condition)
    fprintf('\t L_free: \t\t\t%0.1f mm  \n', spring.L_free*1000);
    fprintf('\t d_i0: \t\t\t\t%0.1f mm  \n', spring.d_i*1000);
    fprintf('\t d_w: \t\t\t\t%0.1f mm  \n', spring.d_w*1000);
    fprintf('\t D_0: \t\t\t\t%0.1f mm  \n', spring.D_0*1000);
    fprintf('\t D_1: \t\t\t\t%0.1f mm  \n', spring.D_1*1000);
    fprintf('\t d_o0: \t\t\t\t%0.1f mm  \n', spring.d_o*1000);
    fprintf('\t N_t: \t\t\t\t%0.1f coils \n', spring.N_t);
    fprintf('\t n_0: \t\t\t\t%0.1f coils \n', spring.n_0);
    fprintf('\t n_1: \t\t\t\t%0.1f coils \n', spring.n_1);
    fprintf('\t p: \t\t\t\t%0.1f mm \n', spring.p*1000);
    fprintf('\t alpha_0: \t\t\t%0.1f degrees \n', spring.alpha_0*180/pi);
    fprintf('\t L_hat: \t\t\t%0.1f mm \n', spring.L_hat*1000);
    fprintf('\t delta: \t\t\t%0.1f mm \n', spring.delta*1000);
    fprintf('\t delta_max: \t\t%0.1f mm \n', spring.delta_max*1000);
    fprintf('\t L_solid: \t\t\t%0.1f mm \n', spring.L_solid*1000);
    fprintf('\t F_1: \t\t\t\t%0.1f N \n', spring.F_1);
    fprintf('\t k_0: \t\t\t\t%0.1f N/m \n', spring.k_0);
    fprintf('\t k_1: \t\t\t\t%0.1f N/m \n', spring.k_1);
    fprintf('\t buckling: \t\t\t%0.1f \n', spring.buckling);
    fprintf('\t C: \t\t\t\t%0.1f \n', spring.C);
    fprintf('\t theta: \t\t\t%0.1f degrees \n', spring.theta);
    fprintf('\t G: \t\t\t\t%0.1f GPa  \n', spring.G*1e-9);
    fprintf('\t nu: \t\t\t\t%0.1f   \n', spring.nu);
    fprintf('\n');
end
