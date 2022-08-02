function PEV= evalpev(des,x,varargin);
% DES_LINEARMOD/EVALPEV
%
% PEV= evalpev(des,x,varargin);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:19 $

m= model(des);
PEV= evalpev(x,m,varargin{:});