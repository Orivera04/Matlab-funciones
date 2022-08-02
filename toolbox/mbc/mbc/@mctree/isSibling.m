function isSib = isSibling(T, otherT)
%ISSIBLING Return true if two nodes are siblings
%
%  ISSIB = ISSIBLING(T1, T2) returns true if T1 and T2 are siblings, that
%  is they share the same parent.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:47:53 $ 

isSib = (T.Parent==otherT.Parent);
