function f= factornames(m,NewNames);
% XREGMODEL/FACTORNAMES input factor names for model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:50 $

if nargin==1
	if isempty(m.Xinfo.Names)
		nf= nfactors(m);
		m.Xinfo.Names= cell(nf,1);
		for i=1:nf
			m.Xinfo.Names{i,1}= sprintf('X%1d',i);
		end
	end
	f= m.Xinfo.Names(:);
else
	if length(NewNames)~=nfactors(m)
		error('Incorrect number of factors')
	end
	m.Xinfo.Names= NewNames(:);
	f=m;
end