function spring = nominal_spring()
	spring.d_i = 0.024;
    spring.d_w = 0.001;
    spring.L_free = 0.100;
    spring.N_t = 7;
    spring.end_condition = 'open_ground';
    spring.G = 79e9;
    spring.nu = 0.3;
end
