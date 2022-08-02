function sz=minsize(obj)
% MINSIZE   Return minimum size of object
%
%   S=MINSIZE(OBJ) returns a 2 element vector indicating the
%   minimum renderable size of the object OBJ.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:22 $

% xregcolorbar has a hard-coded minimum

sz=[100, 150];  %must be over 125 high