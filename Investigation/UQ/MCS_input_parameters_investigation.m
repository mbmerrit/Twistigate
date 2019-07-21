clear;clc;close all

load_path

% load nominal spring
spring = nominal_spring();

% generate random samples
rng('default'); % same random seed for reproductability
N_mc = 1e3; % number of MCS samples
uncertainty = .05;
X(:,1) = unifrnd( (1-uncertainty)*spring.d_i   , (1+uncertainty)*spring.d_i,    N_mc, 1);
X(:,2) = unifrnd( (1-uncertainty)*spring.d_w   , (1+uncertainty)*spring.d_w,    N_mc, 1);
X(:,3) = unifrnd( (1-uncertainty)*spring.L_free, (1+uncertainty)*spring.L_free, N_mc, 1);
X(:,4) = unifrnd( (1-uncertainty)*spring.N_t   , (1+uncertainty)*spring.N_t,    N_mc, 1);

% pack samples
spring_MCS.d_i    = X(:,1);
spring_MCS.d_w    = X(:,2);
spring_MCS.L_free = X(:,3);
spring_MCS.N_t    = X(:,4);
spring_MCS.end_condition = 'open';

% convert parameters
spring_MCS = Convert_Build_Params_vectorize(spring_MCS);

delta_factor = 0.85;
delta = delta_factor * spring_MCS.delta_max;

idx1 = repelem([1;2;3;4],4);
idx2 = repmat([1;2;3;4],4,1);
for i = 1:16
    subplot_id(i,:) = [idx1(i) idx2(i)];
end


fig1 = figure();
set(fig1,'position',[200 200 1200 600])
for k = 1:16
    if subplot_id(k,1) - subplot_id(k,2) == 0
        subplot(4,4,k);hold on;
        histogram(X(:,subplot_id(k,1)),'normalization','pdf')
        xlabel();
    else
        subplot(4,4,k);hold on;
        plot(X(:,subplot_id(k,1)),X(:,subplot_id(k,2)),'.')
    end
end