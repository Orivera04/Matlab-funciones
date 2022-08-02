function sl = depstln(cost,salvage,life) 
%DEPSTLN Straight line depreciation. 
%   SL = DEPSTLN(COST,SALVAGE,LIFE) calculates straight line depreciation for
%   an asset given the COST, SALVAGE value, and depreciable LIFE of the asset.
%   
%   For example, the cost of an asset is $13,000 with a life of 10 years.
%   The salvage value of the asset is $1000.   
% 
%   SL = depstln(13000,1000,10) returns SL = $1200. 
% 
%   See also DEPFIXDB, DEPGENDB, DEPRDV, DEPSOYD. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:08 $ 
 
if nargin < 3 
  error(sprintf('Missing one of COST, SALVAGE, and LIFE data.')) 
end 
sl = (cost-salvage)./life;
