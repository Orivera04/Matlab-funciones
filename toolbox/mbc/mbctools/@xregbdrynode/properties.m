function [inf, w] = properties( bdry )
%PROPERTIES  Return boundary node information
%
%  INF=PROPERTIES(BDRY) returns information for the boundary node
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:13:20 $ 

inf = { 'Constraint Type', 'Boundary' };
w = [80]; 
