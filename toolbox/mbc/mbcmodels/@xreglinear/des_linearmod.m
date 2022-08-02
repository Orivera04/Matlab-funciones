function des= des_linearmod(m,des)
%DES_LINEARMOD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:49:21 $



if ~isempty(m.Store)
	D= m.Store.D;
else
	D= zeros(0,nfactors(m));
end
des= model(des,m);
if ~isa(des,'des_respsurf');
	des= setdesign(des_linearmod,des);
end
des= factorsettings(des,D,'points');
