function [info, w] = properties( bdry )
%PROPERTIES  Return boundary dev information
%
%  INFO=PROPERTIES(BDRY) returns information for the boundary dev node
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 08:13:11 $ 

if isempty( bdry.Model ),
    info = {'Constraint', 'Unset'};
    w = 10;
else
    [info, w] = properties( bdry.Model );
end

nBdry = length( bdry.BdryPoints );
if nBdry > 0, 
    info = [info; {'Number of Boundary Points', int2str( nBdry )}];
    w = [w, 80]; 
end
