function [inf, w] = properties( con )
%PROPERTIES  Return constraint information
%
%  INF=PROPERTIES(CON) returns information for the constraint
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:57:12 $ 

inf = { 'Constraint Type', typename( con ) };

w = [80]; 
