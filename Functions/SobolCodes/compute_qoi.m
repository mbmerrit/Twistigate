function [q_rtc] = compute_qoi(M,X,J,seeds)
N = size(X,1);

%q_rre = zeros(N, 1); % samples of RRE in parameter domain
%q_ssa = zeros(N, M); % samples of SSA realizations in parameter/stochastic domain
%q_cle = zeros(N, M); % samples of CLE realizations in parameter/stochastic domain
q_rtc = zeros(N, M); % samples of RTC realizations in parameter/stochastic domain

parfor i = 1 : N

  % map the ith sample to its physical range
  %X = 0.5*(a+b) + 0.5*(b-a).*Xi(i,:)';

  % show progress every 100 samples
  if mod(i, 5000)==0
     disp(i);
  end

  % RRE evaluation 
  %[q_rre(i)]= qoi(X(i,1), X(i,2), X(i,3), 'rre');

  % ssa and cle evaluations 
  %rng(1234);   % I want the same \omega values for each X realization

  for j = 1 : M
      rng(seeds(j))
     %[q_ssa(i,j)]= qoi(X(i,1), X(i,2), X(i,3), 'ssa');
     %[q_cle(i,j)]= qoi(X(i,1), X(i,2), X(i,3), 'cle',250,J);
     [q_rtc(i,j)]= qoi(X(i,1), X(i,2), X(i,3), 'rtc',J);
  end


end