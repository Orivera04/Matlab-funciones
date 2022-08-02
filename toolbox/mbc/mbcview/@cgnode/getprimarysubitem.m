function p=getprimarysubitem(nd)
%GETPRIMARYSUBITEM  Return the preferred subitem for viewing
%
%  P=GETPRIMARYSUBITEM(ND) returns a pointer to the subitem which 
%  is the preferred start point if ND is the current node
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:59 $

% default is no subitem. 
p=xregpointer;