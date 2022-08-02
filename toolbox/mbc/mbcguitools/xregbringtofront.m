function xregbringtofront(u)
%XREGBRINGTOFRONT  Bring a HG handle to the front of a figure
%
%   XREGBRINGTOFRONT(H)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:17 $


u=handle(u);
% get first sibling
fsib=u.up.down;
if ~(fsib==u)
   u.disconnect;u.connect(fsib,'right');
end