function [tp, name]=DesignType(d,tp,nm)
% DESIGNTYPE  Return the type code and associated string
%
%  [TP, INFO]=DesignType(D)
%  D=DesignType(D, TP, [INFO])
%
%   TP is a code: 0  =>  Unknown/Custom design
%                 1  =>  Optimal design
%                 2  =>  Space Filling design
%                 3  =>  Classical Design
%                 4  =>  Experimental data
%
%   INFO is a field further indicating what the design is.  For TP=0
%   this is always empty.  For TP=1 it may be V-Optimal/D-Optimal, etc.
%   For TP=2 or 3 it will be an actual copy of a CandidateSet object.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:02 $


if nargin>1
   d.style.base=tp;
   if nargin>2
      d.style.baseinfo=nm;
   else
      d.style.baseinfo=[];
   end
   tp=d;
   name=1;
else
   tp=d.style.base;
   name=d.style.baseinfo;
end