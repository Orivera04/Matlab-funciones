function d = frac2cur(p,f) 
%FRAC2CUR Fractional currency values to decimal values. 
%   D = FRAC2CUR(P,F) converts a fractional currency value to a decimal
%   value where P is the fractional currency value and F is the denominator
%   of the fraction.  For example, d = frac2cur('12.1',8) returns d = 12.125. 
%   P is entered as a string value. 
% 
%   See also CUR2FRAC, CUR2STR. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.9 $   $Date: 2002/04/14 21:57:56 $ 
 
if nargin < 2 
  error('Missing one of P and F.') 
end 
 
[rp,cp] = size(p); 
if length(f) == 1 
  f = f*ones(rp,1); 
end 
[rf,cf] = size(f(:)); 
if rp ~= rf 
  disp(char(7)); 
  fprintf(['??? Error using ==> frac2cur\n',... 
           'Dimensions of inputs are inconsistent.\n\n']) 
  return 
end 
 
d = zeros(rp,1); 
for i = 1:rp 
   
  if p(i,1) == '-' 
    coeff = -1; 
    p(i,1) = ' '; 
  else 
    coeff = 1; 
  end 
  % Find the decimal point 
  b = find(p(i,:) == '.'); 
 
  if isempty(b) 
    d(i) = str2double(p(i,:)); 
  else 
    [m,n] = size(p(i,:)); 
    d(i) = coeff*(str2double(p(i,1:b-1))+str2double(p(i,b+1:n))/f(i)); 
  end 
end
