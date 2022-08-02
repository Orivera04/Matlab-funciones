function p=getprimarynode(nd,tp)
%GETPRIMARYNODE  Return the preferred node for viewing
%
%  P=GETPRIMARYNODE(ND,TP) returns a pointer to the node which 
%  is the preferred start point if ND is the first node in a tree
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:58 $

p=address(nd);