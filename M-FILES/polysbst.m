 function [newnum,newden] = polysbst(num,den,subnum,subden);
% POLYSBST : Substitute the variable of a polynomial with another polynomial
%
%function [newnum] = polysbst(num,subnum);
%function [newnum,newden] = polysbst(num,den,subnum,subden);  
%
% Substitute the variable in the original polynomial (num or num/den)
% with a polynomial expression (subnum or subnum/subden).
% The result is returned as a polynomial (newnum or newnum/newden).
% No reduction of the new polynomial is attempted!
%
% Some usefull applications of this are:
%   a)  going from the s to jw domain
%   b)  transformations between continuous to discrete time domains 
%       which are substitutions, like the bi-linear transformation
%   c)  transform (scale/transport/rotate) axis in the root locus plot
if nargin == 2, subnum = den; den = 1; subden = 1; end;
nnum = length(num); nden = length(den);
%
valn = 1; newnum = [];
for ii = nnum:-1:1
  val = num(ii)*valn; valn = conv(valn,subnum);
  for jj = 2-ii:max(0,nden-nnum); val = conv(val,subden); end;
  newnum = poly_add(newnum,val);
end;
%
vald = 1; newden = [];
for ii = nden:-1:1
  val = den(ii)*vald; vald = conv(vald,subnum);
  for jj = 2-ii:max(0,nnum-nden); val = conv(val,subden); end;
  newden = poly_add(newden,val);
end;
