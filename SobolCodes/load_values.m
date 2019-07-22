function ValueStruct = load_values(A_mat,end_condition)
% Converts the values in a matrix to a struct for the Sobol code
[N,M] = size(A_mat);
for i = 1:N
    spring_A.d_i = A_mat(i,1);
    spring_A.d_w = A_mat(i,2);
    spring_A.L_free = A_mat(i,3); 
    spring_A.N_t = A_mat(i,4);
    spring_A.nu = A_mat(i,5);
    spring_A.delta = A_mat(i,6);
    spring_A.end_condition = end_condition;
    ValueStruct{i} = spring_A;
end