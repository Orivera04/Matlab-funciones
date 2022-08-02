function md=GUID(md, ID)
% GUID  get/set modeldev GUID
%
%   md=GUID(md, ID)
%   ID=GUID(md)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:25 $

% Created 4/12/2000


if nargin>1
   md.ViewIndex=ID;
   pointer(md);
else
   md=md.ViewIndex;
end