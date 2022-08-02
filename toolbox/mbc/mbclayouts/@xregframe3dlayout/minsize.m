function sz=minsize(obj)
% MINSIZE   Return minimum size of object
%
%   S=MINSIZE(OBJ) returns a 2 element vector indicating the
%   minimum renderable size of the object OBJ.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:37 $


h=get(obj,'elements');
if length(h)
   sz=minsize(h{1});
end

sz=sz+[4 4];


