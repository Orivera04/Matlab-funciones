function obj = shrinkwrap(obj)
% Synopsis
%
%  function obj = shrinkwrap(obj)
%
% Details
%  
%  Wraps the container around the enclosed elements so that the 
%  container is as small as possible.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:36:01 $

h = get(obj.xregcontainer,'elements');
b = get(obj.xregcontainer,'border');
p = position(h);
p = p + [-b(1) -b(2) b(1)+b(3) b(2)+b(4)];

set(obj.xregcontainer,'position',p);


