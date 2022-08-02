function m=rmfactors(m,f);
% MODEL/RMFACTORS remove factors from model
%
% m=rmfactors(m,f);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:59 $

if ~isempty(m.code)
   m.code(f)=[];
   m.Xinfo.Names(f)=[];
   m.Xinfo.Units(f)=[];
   m.Xinfo.Symbols(f)=[];
	
	m2= feval(class(m),'nfactors',length(m.code));
	m= copymodel(m,m2);
end