
tic
ndim = 6;

%
% some initialization
%
N = 1e3;  % number of random samples

% nominal parameter values with everything +/- 10%
% parameters: d_i, d_w, L_f, N_t, nu, delta   (end condition is also one)
k1 = .0240;  % inner diameter (m)
k2 = 1e-3;  % wire diameter (m)
k3 = .100;  % free length (m)
k4 = 9;  % total coils
k5 = .3;  % Poisson's ratio
k6 = .05;  % deflection (m)  this should be computed iteratively
mu = [k1; k2; k3; k4; k5; k6];   % mean of the parameters
end_condition = 'open_ground';  % this will now always be the EC!

%
% start with 10% pertrubation around mean
%
unc = .1;
a = mu - unc*mu;
b = mu + unc*mu;

%
% parameter samples (generate U[-1,1] realizations)
%
XA = -1 + 2*rand(N, ndim); 
XB = -1 + 2*rand(N, ndim); 

A_mat = repmat(0.5*(a+b)',N,1) + 0.5*(b-a)'.*XA;
B_mat = repmat(0.5*(a+b)',N,1) + 0.5*(b-a)'.*XB;

% Now we compute deflection iteratively...

% load the random values into a cell array
A = load_values(A_mat, end_condition);
B = load_values(B_mat, end_condition);

%
% sampling loop
%
for i = 1:N
    if mod(i,1e4) == 0
        disp([num2str(i),' of ',num2str(N)])
    end
    % First convert manufacturing units to engineering with end conditions
    Eng_A{i} = Convert_Build_Params(A{i});
    Eng_B{i} = Convert_Build_Params(B{i});
    qA(i) = compute_theta(Eng_A{i}, Eng_A{i}.delta); 
    qB(i) = compute_theta(Eng_B{i}, Eng_B{i}.delta);
end  
qA = qA';  % just give them the right dimensions
qB = qB';
clear Eng_A % this just saves on storage
clear Eng_B

 
    % Now unpack A and B for restructuring
for k = 1:ndim % this substitutes one column of B into each A, then evaluates
    disp(['k = ',num2str(k)])
    C_orig = A_mat;    % C_orig is just a dummy variable
    C_orig(:,k) = B_mat(:,k);  % here you are varying one parameter at a time
    C = load_values(C_orig, end_condition);
    for i = 1:N
        if mod(i,1e4) == 0
           disp([num2str(i),' of ',num2str(N)])
        end
        Eng_C{i} = Convert_Build_Params(C{i});
        qC(i,k) = compute_theta(Eng_C{i}, Eng_C{i}.delta); 
    end
end
clear C_orig
clear Eng_C
size(qA)
size(qB)
size(qC)

% Here is where we compute the Sobol' Indices - just first order and total
[Total Single] = get_sobol_indices(qA, qB, qC);
[NN,MM] = size(qA);

toc


bar([Total;Single]', 1)
xtik = {'d_i', 'd_w','L_f','N_t','\nu','\delta'};
set(gca, 'XTickLabel', xtik,'fontsize',20)
title(['Sobol Indices - $\delta$ fixed at 50 mm, $\epsilon = $',num2str(100*unc),'\%'],'interpreter','latex')
legend('Total','First Order')
