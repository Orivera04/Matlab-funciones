function i=findpoints(c,inds)
% FINDPOINTS   Find the given points in the constraints list
%
%  I=FINDPOINTS(C,INDS) searches the list of constrained points
%  in C for the indices INDS and returns their positions in I.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:51 $


i=fastfind(c.InteriorPoints,inds);
return
