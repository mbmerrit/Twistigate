How to use the Twistigate code base (writing code utilizing the formulation):
	1. Create your script in the Investigations directory
	2. Load the functions into Matlab path
	3. Set spring design parameters (suggest loading nominal spring and modifying as needed)
	4. Call spring_metrics function to calculate the final parameters

Some example code is below.

''' matlab
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
	my_spring.end_condition = 'open-ground';

	% shear modulus
	my_spring.G = 79e9;

	% final compressed height of spring
	my_spring.L_hat = 0.025;

	% compute spring characteristics as final state
	my_spring = spring_metrics(my_spring);

	% if you want to print the output, call the function  with the additional parameter true
	my_spring = spring_metrics(my_spring, true);



'''
