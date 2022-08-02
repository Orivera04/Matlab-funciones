function n=tablenode(node,p)
%TABLENODE Create an appropriate table node
%
%  n = TABLENODE(n,p_tbl) creates a tradeofftblnode for p_tbl.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:38:47 $

% create a table node that is tailored for tradeoff usage
n = cgtradeofftblnode(p);