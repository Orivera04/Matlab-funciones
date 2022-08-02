function out = evalmodel(f,X)
% cgFuncModel \ eval
% out = eval(F,X)
% This code is vectorised and expects an nxm matrix where n is the number of data 
% points and m is the number of factors
%
%	Evaluates a function model object, F
%	Input ordering can be found by argnames(F) 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:49:48 $
if ~iscell(X)
	for i=1:size(X,2)
		data{i} = X(:,i);
	end
	X = data;
end
out = feval(f.funcv,X{:});
if ~isa(out,'double')
    out=double(out); 
end 


