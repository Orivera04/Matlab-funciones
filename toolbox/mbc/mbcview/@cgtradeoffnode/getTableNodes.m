function pNodes = getTableNodes(obj)
%GETTABLENODES Return list of pointers to table nodes
%
%  PNODES = GETTABLENODES(OBJ) returns the list of table nodes that are
%  children of the tradeoff.  Use this method to insulate your code from
%  the effects of other, non-table, nodes beign added to the tradeoff
%  architecture.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:40 $ 

pNodes = children(obj);
