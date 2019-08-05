function [T S] = get_sobol_indices(YA_full,YB_full,YC_full)
ndim = 6;
[N,M] = size(YA_full);
T = zeros(M,ndim);
S = zeros(M,ndim);

if M > 1
for i = 1:M
    % Get vectors of quantities for each M
    YA = YA_full(:,i);
    YB = YB_full(:,i);
    YC = squeeze(YC_full(:,i,:));
    
    % Estimate mean and variance
    muYA = mean(YA);
    muYB = mean(YB);
    Var_Y = (1/2)*mean( (YA-muYA).^2 + (YB-muYB).^2 );

    % Estimate Sobol' indices
    for k = 1:ndim
        S(i,k) = mean( YB.*(YC(:,k)-YA) )/Var_Y;
        T(i,k) = (1/2)*mean( (YA - YC(:,k)).^2 )/Var_Y;
    end
end  
else
    YA = YA_full;
    YB = YB_full;
    YC = YC_full;
    muYA = mean(YA_full);
    muYB = mean(YB_full);
    Var_Y = (1/2)*mean( (YA-muYA).^2 + (YB-muYB).^2 );

    % Estimate Sobol' indices
    for k = 1:ndim
        S(k) = mean( YB.*(YC(:,k)-YA) )/Var_Y;
        T(k) = (1/2)*mean( (YA - YC(:,k)).^2 )/Var_Y;
    end
end

        
end