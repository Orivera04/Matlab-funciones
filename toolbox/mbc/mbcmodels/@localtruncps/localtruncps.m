function ts = localtruncps(ord,knots)
%LOCALTRUNCPS Constructor for truncated power series model
%
%  M = LOCALTRUNCPS constructs a local power series model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:43:08 $

if nargin==0
    ord= 3;
    knots=1;
end

ts.knots  = knots;
ts.order  = ord;

mlin = xreglinear('nfactors',1);
mlin = update(mlin,ones(ts.order+length(ts.knots),1));

ts = class(ts,'localtruncps',localmod,mlin);

n = size(ts,1);
ts = AddFeat(ts,zeros(n,1),1:n);
