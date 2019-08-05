
tic
%
% some initialization
%
N = 1e5;  % number of random samples
ndim = 6;
load_path


% parameters: d_i, d_w, L_f, N_t, nu, delta   (end condition is also one)
k1 = .0240;  % inner diameter (m)
k2 = 1e-3;  % wire diameter (m)
k3 = .1000;  % free length (m)
k4 = 9;  % total coils
k5 = .3;  % Poisson's ratio
%k6 = .05;  % deflection (m)  this should be computed iteratively
Lhat = .025; % this is the deflected height
mu = [k1; k2; k3; k4; k5];   % mean of the parameters
end_condition = 'open_ground';  % this will now always be the EC!

% Now we don't use +/- x% tolerances, but we got custom
% Parameters (in order): d_i, d_w, L_f, N_t, nu
%unifrnd([.0235, .00095, .08, 6.5, .27],[.0245, .00105, .12, 7.5, .33], [1,5])
A_mat = [unifrnd(.0235,.0245,[N,1]), unifrnd(9.5e-4,1.05e-3,[N,1]), ...
    unifrnd(.08,.12,[N,1]), unifrnd(6.5,7.5,[N,1]), unifrnd(.27,.33,[N,1])];

B_mat = [unifrnd(.0235,.0245,[N,1]), unifrnd(9.5e-4,1.05e-3,[N,1]), ...
    unifrnd(.08,.12,[N,1]), unifrnd(6.5,7.5,[N,1]), unifrnd(.27,.33,[N,1])];

delta_A = A_mat(:,3) - Lhat; 
A_mat = [A_mat delta_A];
delta_B = B_mat(:,3) - Lhat; 
B_mat = [B_mat delta_B];


% load the random values into a cell array
A = load_values(A_mat, end_condition);
B = load_values(B_mat, end_condition);

%
% sampling loop
%
qA = zeros(N,1);
Eng_A = cell(1,N);
qB = zeros(N,1);
Eng_B = cell(1,N);
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
qA = qA;  % just give them the right dimensions
qB = qB;
clear Eng_A
clear Eng_B

% Pre allocate memory
qC = zeros(N,ndim);
Eng_C = cell(1,N);

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
%         if k == 3
%         C{i}.L_free - C{i}.delta
%         end
         % THIS IS IMPORTANT, we now enforce again delta = Lfree - Lhat
         if k == 3 %varying Lfree
             C{i}.delta = C{i}.L_free - Lhat;
         end
         if k == 6 % varying delta
            C{i}.L_free = C{i}.delta + Lhat;
         end
         Eng_C{i} = Convert_Build_Params(C{i});
         qC(i,k) = compute_theta(Eng_C{i}, Eng_C{i}.delta); 
    end
end
clear C_orig
clear Eng_C

% Here is where we compute the Sobol' Indices - just first order and total
[Total Single] = get_sobol_indices(qA, qB, qC);
toc

bar([Total;Single]', 1)
xtik = {'d_i', 'd_w','L_f','N_t','\nu','\delta'};
set(gca, 'XTickLabel', xtik,'fontsize',20)
title(['Sobol Indices - $\hat{L} = L_{free} - \delta = 25 mm$ , Custom Tolerances'],'interpreter','latex')
legend('Total','First Order','location','best')

