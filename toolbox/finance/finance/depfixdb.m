function d = depfixdb(cost,salvage,life,period,month) 
%DEPFIXDB Fixed declining-balance depreciation. 
%   D = DEPFIXDB(COST,SALVAGE,LIFE,PERIOD,MONTH) calculates D, the fixed 
%   declining-balance depreciation for the period.  COST is the initial value
%   of the asset, SALVAGE is the salvage value of the asset, LIFE is the life  
%   of the asset in years, and PERIOD is the number of periods used to perform  
%   perform the calculation.  The default value for MONTH is 12, which    
%   represents the number months in the first year of the life of the asset.  
% 
%   For example, a car is purchased for $11,000 with a salvage value $1500 
%   and a lifetime of eight years. To calculate the depreciation for the
%   first five years:
%       
%   d = depfixdb(11000,1500,8,5)
%       
%   returns d = [2425.08 1890.44 1473.67 1148.78 895.52]
% 
%   See also DEPGENDB, DEPRDV, DEPSOYD, DEPSTLN. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:55:56 $ 
 
if nargin < 5 
  month = 12;  % Default MONTH is 12 
end 
if nargin < 4 
  error(sprintf('Missing one of COST, SALVAGE, LIFE, and PERIOD.')) 
end 
 
% Determine depreciation rate 
rate = 1-((salvage./cost).^(1./life)); 
 
d(1) = cost.*rate.*month/12;  % RDV after first period 
if abs(d(1) - cost-salvage) < 1e-6 
  d(2) = []; 
else 
  d(2) = (cost-d(1)).*rate;   % RDV after second period 
  n = 3:period-1;             % Variation in length of n prohibits vectorization 
  d(n) = (1-rate).^(n-2)*d(2); 
end 
 
if month == 12 
  month = 0; 
end 
 
% Determine depreciable value remaining after last period 
if sum(d) >= cost-salvage 
  d(period) = 0; 
else 
  d(period) = ((cost-sum(d))*rate*(12-month))/12; 
end 

