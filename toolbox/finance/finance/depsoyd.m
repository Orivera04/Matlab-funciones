function sd = depsoyd(cost,salvage,life) 
%DEPSOYD Sum of years' digits depreciation. 
%   SD = DEPSOYD(COST,SALVAGE,LIFE) calculates the depreciation for an asset
%   using the sum of years' digits method given the COST, SALVAGE value, and
%   depreciable LIFE of the asset.  SD is a vector of depreciation values
%   with each element corresponding to a year of the asset's life.   
% 
%   For example, the cost of an asset is $13,000 with a life of 10 years. 
%   The salvage value of the asset is $1000.  
%
%      SD=depsoyd(13000,1000,10)
%       
%      returns SD = [2181.82 1963.64 1745.45 1527.27 1309.09
%                   1090.91 872.73 654.55 436.36 218.18]
%
%      The depreciation for the fifth calendar year is SD(5) or $1309.09. 
% 
%   See also DEPFIXDB, DEPGENDB, DEPRDV, DEPSTLN. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:05 $ 
 
if nargin < 3 
  error(sprintf('Missing one of COST, SALVAGE, and LIFE.')) 
end 
if cost < salvage 
  error(sprintf('Enter COST >= SALVAGE.')) 
end 
 
yr = 1:life; 
sd = (cost-salvage)/(life/2*(life+1))*(life-yr+1);
