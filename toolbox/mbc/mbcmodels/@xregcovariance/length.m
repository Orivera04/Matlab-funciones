function nw= length(c)
%LENGTH

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:21 $

if ~isempty(c.wparam)
   nw= length(c.wparam);
elseif ~isempty(c.wfunc)
   [nw,bnds]= feval(c.wfunc);
else
   nw=0;
end

nw= nw+length(c.cparam(:));