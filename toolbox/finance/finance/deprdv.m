function r = deprdv(cost,salvage,accum) 
%DEPRDV Remaining depreciable value. 
%   R = DEPRDV(COST,SALVAGE,ACCUM) returns the remaining depreciable value for
%   an asset given the COST, SALVAGE value, and the accumulated depreciation 
%   ACCUM of the asset for the prior periods.   
% 
%   For example, the cost of an asset is $13,000 with a life of 10 years.  
%   The salvage value of the asset is $1000.  To find the remaining depreciable
%   value after 6 years, use the following commands.  Find the accumulated 
%   depreciation with the straight-line depreciation function, DEPSTLN. 
% 
%   accum = depstln(13000,1000,10)*6 = 7200. 
%   r = deprdv(13000,1000,7200) = 4800. 
% 
%   See also DEPFIXDB, DEPGENDB, DEPSOYD, DEPSTLN. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:02 $ 
 
if nargin < 3 
  error('Missing one of COST, SALVAGE, and ACCUM.') 
end 
 
r = cost-salvage-accum;
