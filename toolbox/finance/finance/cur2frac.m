function f = cur2frac(p,d) 
%CUR2FRAC Decimal currency values to fractional values. 
%   F = CUR2FRAC(P,D) converts decimal currency values to fractional values
%   where P is the decimal currency value and D is the denominator of the 
%   fraction.  F is returned as a string value. 
% 
%   For example, f = cur2frac(12.125,8) returns f = 12.1.  
% 
%   See also FRAC2CUR, CUR2STR. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:55:50 $ 
 
if nargin < 2 
  error('Missing one of P and D.') 
end 
 
if length(p) == 1 
  p = p*ones(size(d)); 
end 
if length(d) == 1 
  d = d*ones(size(p)); 
end 
 
if checksiz([size(p);size(d)],mfilename);return;end 
 
pnum = length(p(:)); 
f = [];
for i = 1:pnum 
 
  if p(i) < 0 
    coeff = -1; 
  else  
    coeff = 1; 
  end 
 
  frac = abs(round(rem(p(i),1)*d(i))); 
  if frac == d(i) 
    crt = coeff; 
    frac = 0; 
  else  
    crt = 0; 
  end 
  if frac < 10 
    remain = fliplr(num2str(frac*10^floor(log10(d(i))))); 
  else 
    remain = num2str(frac); 
  end 
  sf =[num2str(coeff*floor(abs(p(i)))+crt),'.',remain]; 
  f = str2mat(f,sf); 
end 
f(1,:) = [];
