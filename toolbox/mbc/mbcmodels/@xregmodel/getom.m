function Val= getFitOpt(m,Prop)
%GETOM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:02 $

if nargin==1;
	Val= m.FitAlgorithm;
else
	Val= get(m.FitAlgorithm,Prop);
end