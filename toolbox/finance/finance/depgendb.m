function d = depgendb(cost,salvage,life,factor) 
%DEPGENDB Declining-balance depreciation. 
%   D = DEPGENDB(COST,SALVAGE,LIFE,FACTOR) calculates D, the declining-balance
%   depreciation for each period.  COST is the cost of the asset and SALVAGE
%   is the estimated salvage value of the asset.  LIFE is the number of periods 
%   over which the asset is depreciated and FACTOR is the depreciation factor.  
%   A FACTOR of 2 uses the double-declining-balance method.   
% 
%   For example, a car is purchased for $11,000 and is to be depreciated  
%   over 5 years.  The estimated salvage value is $1000.  Using the  
%   double-declining-balance method, the depreciation for each year is
%   calculated and also returned is the remaining depreciable value at
%   the end of the life of the car. 
% 
%   d = depgendb(11000,1000,5,2) returns  
% 
%   d = [4400.00,2640.00,1584.00,950.40,425.60]. 
% 
%   See also DEPFIXDB, DEPRDV, DEPSOYD, DEPSTLN. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.8 $   $Date: 2002/04/14 21:55:59 $ 
 
if nargin < 4 
  error('Missing one of COST, SALVAGE, LIFE, and FACTOR.') 
end

if prod(size([cost(:) ; salvage(:) ; life(:) ; factor(:)])) ~= 4
  error('All inputs must be scalars.');
end

if life == 1     % case where life = 1 period 
  life = 2; 
  oldlife = 1; 
else
  oldlife = 0;
end 
if checkrng('life',life,0,inf,'0','inf','l','l',mfilename)  % life > 0 
  return 
end 
 
m = length(cost); 
cs = cost-salvage; 
span = 1:life-1; 
yr = span(ones(m,1),:); 
n = life-1; 
d(yr) = (cost(:,ones(n,1)).*factor(:,ones(n,1))./life).*... 
        (1-factor(:,ones(n,1))./life).^(yr-1); 
len = length(d); 
% Sum of depreciation per year should never be greater than cost-salvage 
totald = cumsum(d); 
i = find(totald > cs); 
if ~isempty(i)
  if i == 1 
    d(i) = cs;  
  else 
    d(i) = cs-totald(i-1); 
  end 
  zs = i(1)+1:len; 
  d(zs) = zeros(size(zs)); 
end
sumd = sum(d); 
if sumd > cs 
  d(len+1) = 0; 
else 
  d(len+1) = cs-sumd; 
end 
if oldlife == 1 
  d = d(1,1); 
end
