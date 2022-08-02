 function [numsum,densum] = poly_add(num1,den1,num2,den2);
% POLY_ADD : Addition of two polynomials
%
%function [numsum] = poly_add(num1,num2);
%function [numsum,densum] = poly_add(num1,den1,num2,den2);
%
% Add 2 polynomials with leading zeros removed
% Accepts either form : (num1 + num2) or ((num1/den1) + (num2/den2))
% No reduction of common roots (numerator and denominator) is attempted
if nargin > 2
  densum = conv(den1,den2);  
  num1 = conv(num1,den2);
  num2 = conv(num2,den1);
else
  num2 = den1;
end;
nnum1 = length(num1); nnum2 = length(num2);
if (nnum1 > nnum2); num2 = [zeros(1,nnum1-nnum2) num2]; end;
if (nnum2 > nnum1); num1 = [zeros(1,nnum2-nnum1) num1]; end;
numsum = num1+num2;
% REMOVE LEADING ZEROS, BUT DON'T REDUCE THE SUM TO NUL!
ii = find(numsum ~= 0);
if (isempty(ii)); numsum = [0]; ii = 1; end;
if (ii(1) > 1); numsum = numsum(ii(1):length(numsum)); end;
if nargin > 2
  ii = find(densum ~= 0);
  if (isempty(ii)); densum = [0]; ii = 1; end;
  if (ii(1) > 1); densum = densum(ii(1):length(densum)); end;
end;  
