function [spring] = Optimize_Twist(Fhat, Lhat, nu, G)
% SAMSI IMSM Team Twistigate 2019
% Takes force, Lhat, Poisson ratio and G and optimizes to reduce twist
if length(fieldnames(spring)) < 5
    disp('invalid number of inputs')
end

