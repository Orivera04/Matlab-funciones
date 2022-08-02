function [info, w] = properties( con )
%PROPERTIES  Return constraint information
%
%  INF=PROPERTIES(CON) returns information for the constraint
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:59:08 $ 

info = { ...
        'Constraint Type', 'Star Shaped';...
        'Transform', con.Transform;...
    };
w = [80, 80]; 

dr = get( getbdrypointoptions( con ), 'ActualDilationRadius' );
if dr >= 0,
    info = [ info; { 'Dilation', num2str( dr ) } ];
    w = [w, 80]; 
end
