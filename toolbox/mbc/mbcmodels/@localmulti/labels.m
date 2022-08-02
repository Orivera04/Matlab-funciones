function lab= labels(L,varargin);
%LOCALMULTI/LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:40:02 $

m= get(L,'currentmodel');
if isa(m,'xregcubic') | isa(m,'xreg3xspline')
   lab= labels(m,varargin{1},0);
   lab= lab(Terms(m));
else
   lab= labels(m,varargin{:});
end



