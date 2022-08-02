function [inf, w] = properties( bdry )
%PROPERTIES  Return root boundary node information
%
%  INF=PROPERTIES(BDRY) returns information for the boundary root
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 08:13:37 $ 

data = getdata( bdry );

inf = { ...
        'Number of Factors', int2str( size( data, 2 ) ); ...
        'Number of Data Points', int2str( size( data, 1 ) ); ...
    };

w = [50, 50]; 

[inf2, w2] = i_best( bdry );

inf = [inf; inf2];
w = [w, w2];

return

%---------------------------------|--------------------------------------------|
function [str, w] = i_best( b )

n = size( b.Best, 2 );

if n == 0,
    str = { 'Best Model', 'Unset' };
elseif n == 1,
    str = { 'Best Model', b.Best.name };
else
    str = { 'Best Models', name( info( b.Best(1) ) ) };
    for i = 2:n,
        str = [ str; {'', name( info( b.Best(i) ) )} ];
    end
end
w = repmat( 50, 1, max( 1, n ) );

return
%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
