function n=tablenode(featnode,p)
%TABLENODE  Create an appropriate table node
%
%  n=tablenode(n,p_tbl)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:12 $

% create a table node that is tailored for feature usage
n=cgfeattblnode(p);