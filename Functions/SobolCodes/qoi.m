function [q] = qoi(k1, k2, k3, method,J)

if nargin < 3
   k1 = 1e6;
   k2 = 1e-4;
   k3 = 0.1;
end 

% uniform time mesh (probably not needed)
ti = [0 : 0.01 : 50];


switch method
   case 'rre'
      %[t y] = rre_mm(k1, k2, k3); 
   case 'cle'
      %[t y] = cle_mm(Nt, k1, k2, k3, J); 
   case 'ssa'
      %[t y] = ssa_mm(k1, k2, k3);
   case 'rtc'
      [t y] = rtc_mm(k1, k2, k3,J);
   otherwise
      error('unknown method, use rre, cle, rtc, or ssa');
end

% interpolate response (can be done in more smart way)
%yi = interp1(t, y, ti);


q = trapz(t,y(:,4));
%q =  trapz(ti, yi(:,2));  % average of the product over [0, 50]
