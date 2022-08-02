function m=loadobj(m);
% xreglinear/LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:44 $

if isa(m,'struct');
  m= xreglinear(m);
end
if isempty(var(m)) & ~isempty(m.Store) & isfield(m.Store,'R') & isfield(m.Store,'mse')
	% move stats to model stats store
	R= m.Store.R;
	rd= max(abs(diag(R)));
	if ~isempty(R) & abs(diag(R)) > eps*size(R,1)*rd
		ri= calcRi(m);
	else
		ri= [];
	end
	mse= m.Store.mse;
	if ~isempty(ri) & ~isempty(mse)
		ri= ri*sqrt(mse);
	end
	if isfield(m.Store,'X')
		df= size(m.Store.X,1)-numParams(m);
	else
		df= Inf;
	end
	m= var(m,ri,mse,df);
end
