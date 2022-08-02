function out = eval(f,X)
% cgFuncModel \ eval
% out = eval(F,X)
% This code is vectorised and expects an nxm matrix where n is the number of data 
% points and m is the number of factors
%
%	Evaluates a function model object, F
%	Input ordering can be found by argnames(F) 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:53 $

%X is an NxNum_Inputs Matrix
Xc = num2cell(X,1);
out = feval(f.funcv,Xc{:});