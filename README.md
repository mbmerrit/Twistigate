How to use the Twistigate code base (writing code utilizing the formulation):
1. Create your script in the Investigations directory
2. Load the functions into Matlab path
3. Set spring design parameters (suggest loading nominal spring and modifying as needed)
4. Call spring_metrics function to calculate the final parameters

Some example code is below.

```

load_path;

% load default spring parameters - helps to avoid typos
my_spring = nominal_spring();

% All parameters are in uncompressed state here (except as noted)
	
% inner diameter, meters
my_spring.d_i = 0.024;

% wire diameter, meters
my_spring.d_w = 0.001;

% free length, meters
my_spring.L_free = 0.100;

% number of TOTAL coils
my_spring.N_t = 7;

% end condition of spring
my_spring.end_condition = 'open_ground';

% shear modulus
my_spring.G = 79e9;

% final compressed height of spring
my_spring.L_hat = 0.025;

% compute spring characteristics as final state
my_spring = spring_metrics(my_spring);

% if you want to print the output, call the function  with the additional parameter true
my_spring = spring_metrics(my_spring, true);

```

How to use the Optimize_Twist_F_Constrained-
 All inputs in SI units
 Takes force, Lhat, init_spring_params = [N_t_init;d_i_init; d_w_init;
 L_free_init], weight for theta and weight for force constraint and 
 optimizes to reduce twist, while keeping force constrained to Fhat (N) at
 the compressed height of Lhat (m). Outputs a spring struct with all optimized parameters.

Inputs for the Optimization function to optimize theta at a given force constraint:
Optimize_Twist_F_Constrained(Fhat, Lhat,init_spring_params, beta_1,beta_2)
1. Fhat (in Newton)
2. Lhat (in m)
3. Init_spring_params= Vector to set initial spring design parameters. If [] added, nominal parameters are used.
4. beta_1 = weight for theta in the optimization function. If [] added, 1e4 is used by default.
5. beta_2 = weight for force constraint in the optimization function. If [] added, 1e-4 is used by default.
