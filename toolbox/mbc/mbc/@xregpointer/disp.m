function disp(pp)
%DISP methods for xregpointer
%
% This gets called by the MATLAB editor for the 'onHover' datatips.
% The idea here that for each pointer in an area we see something like
%
%  &N (pObject)
%
%
% dispString = '';

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 06:47:02 $


% get which pointers are valif
valid = isvalid(pp);
nump = numel( pp.ptr );

dispString = cell( size( pp ) );

for n = 1:nump
    addressString = sprintf('&%d', pp.ptr(n));
    if pp.ptr(n)==0    
        classString = '';        
    elseif valid(n)        
        classString = sprintf('(%s)', class( HeapManager( 0, pp.ptr(n) ) ) );
    else
        classString = '(INVALID)';        
    end
    dispString{n} = sprintf('  %s %s', addressString, classString);
end

% print each each row 
for r = 1:size(dispString, 1)
    fprintf( '%s\n', [dispString{r, :}] );
end
