function F= contextImplementation(F,m,RunFcn,CostFcn,name,caller);
% FITALGORITHM/LSQNONLIN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:41 $

% function handles to run and setup functions
F.RunFcn      = RunFcn;
if nargin>3
	F.costFunc     = CostFcn;
else
	F.costFunc= '';
end
F.Context     = class(m);

F.algorithm   = {'contextImplementation',caller};

if nargin>4
	F.name= name;
else
	F.name= func2str(RunFcn);;
end

