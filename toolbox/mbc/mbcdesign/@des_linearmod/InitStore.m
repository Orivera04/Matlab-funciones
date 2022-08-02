function smod= InitStore(smod,X);
% DES_LINEARMOD/INITSTORE
%
% smod= InitStore(smod)      initialises models with current design
% smod= InitStore(smod,X)    initialises models with X

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:11 $

if nargin==1;
	X= factorsettings(smod);
end
m=model(smod);
m = InitStore(m,X);
smod=InsertModel(smod,m);