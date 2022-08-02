function out = numoutputs(M)
%NUMOUTPUTS
%  Some xregexportmodels can have multiple outputs so this method 
%  returns the number of outputs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:22 $

m = M.model;
if isempty(m)
	out = 1;
else
	out = numoutputs(m);
end