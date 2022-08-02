function f1=SelFeat(f,ind);
% LOCALMOD/SELFEAT select set of response features

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:45 $

f1= f;
f1.Values=f1.Values(ind,:);
f1.Type=f1.Type(ind);
f1.Limits= f1.Limits(:,ind);
if isempty(f1.delG)
	f1=EvalDelG(f1);
else
	f1.delG= f1.delG(ind,:);
end
