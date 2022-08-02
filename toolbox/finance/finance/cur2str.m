function t = cur2str(p,d) 
%CUR2STR Bank formatted text. 
%   T = CUR2STR(P,D) returns the given value in bank format.  P is the value 
%   to be formatted and D is the number of significant digits. A negative D 
%   rounds the value to the left of the decimal point.  Negative numbers are  
%   displayed in parenthesis and T is returned as a string. By default, D = 2.
%        
%   For example, t = cur2str(-8264,2) returns t = ($8264.00). 
%  
%   See also FRAC2CUR, CUR2FRAC. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.8 $   $Date: 2002/04/14 21:55:53 $ 
 
if nargin == 1 
  d = 2; % Prices are returned to two significant digits  
end 
if nargin < 1 
  error('Missing price data, P.') 
end 
if length(p) == 1 
  p  = p*ones(size(d)); 
end 
if length(d) == 1 
  d = d*ones(size(p)); 
end 
if checksiz([size(p);size(d)],mfilename);return;end 
 
pnum = length(p(:)); 
t = [];
for i = 1:pnum 
 
  if d(i) > 15 
    d(i) = 15; 
  end 
 
z = abs(p(i)); 
a = round(z*10^d(i)); 
 
prec = length(sprintf('%f',p(i)))+d(i);
if d < 0 
  b = int2str(a); 
else 
  b = num2str(a,prec); 
end 
 
if p(i) < 0 % Negative numbers are enclosed in parenthesis 
  if d(i) < 0 
    st = ['($',b,num2str(zeros(1,abs(d(i)))),')']; 
  else  
    it = ['($',b,')']; 
    k = max(size(it)); 
    st = [it(1:k-d(i)-1),'.',it(k-d(i):k)]; 
  end 
else 
  it = ['$',b]; 
  k = max(size(it)); 
  if d(i) < 0 
    st = [it,num2str(zeros(1,abs(d(i))))]; 
  else  
    st = [it(1:k-d(i)),'.',it(k-d(i)+1:k)]; 
  end 
end 
 
%eliminate blanks
j = find(st == ' ');
st(j) = [];

t = str2mat(t,st); 
end  %end for 

%eliminate first row which is blank
t(1,:) = [];
