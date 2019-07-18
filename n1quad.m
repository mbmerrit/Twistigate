function [n_1] = n1quad(n0, L, H0, H1, R0, nu)
% SAMSI IMSM Team Twistigate 2019
% Computes R_1 using Equation derived in the overdrive project folder
% in terms of variables found in the paper of Michalczyk (2009). 
A =((H0-H1)*H1)/(R0^3*n0*2*pi*(1+nu)*L);
B = R0/((H0/(2*pi*n0))^2+R0^2);
C = -(L^2-H1^2)/L^2;
Det=sqrt(B^2-4*A*C);
R_1=(-B+Det)/(2*A);
n_1=sqrt(L^2-H1^2)/(2*pi*R_1);

