function [info, w] = properties( con )
%PROPERTIES  Return constraint information
%
%  INF=PROPERTIES(CON) returns information for the constraint
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:46 $ 

info = { ...
        'Constraint Type', 'Two-stage';...
        'Local Constraint', typename( con.Local );...
        'Global Models', name( con.Global{1} );...
};
w = [80, 80, 80]; 
