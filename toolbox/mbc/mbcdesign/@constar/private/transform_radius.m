function RT = transform_radius( R, T, I )
%TRANSFORM_RADIUS transformation of radial values to ensure positivity
%   TRANSFORM_RADIUS(R,T) transforms the values (radii) in R by the 
%   transformation T. This sort of transformations can be used to change 
%   the distribution of the input radii and thereby ensure that the output 
%   radii are positive.
%
%   TRANSFORM_RADIUS(R,T,'Inverse') inverts the transform.
%
%   TRANSFORM_RADIUS('List') returns a cell array of possible options for
%   the transform.
%
%   Choose the transformation from 
%    None       R --> R
%    Log        R --> log( R );
%    McCallum   R --> R + 1/R

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:59 $ 

nargchk( 1, 3, nargin );
if ischar( R ),
    RT = { 'None', 'Log', 'McCallum' };
    return
end

if nargin < 2, 
    T = 'None'; 
end

if nargin < 3.
    switch lower( T )
    case {'none', 'identity'},
        % do nothing
        RT = R;
    case 'log',
        RT = log( R );
    case 'mccallum',
        RT = R - 1./R;
    otherwise
        error( sprintf( 'Unknown transform function: ''%s''', T ) );
    end
elseif strcmpi( 'inverse', I )
    switch lower( T )
    case {'none', 'identity'},
        % do nothing
        RT = R;
    case 'log',
        RT = exp( R );
    case 'mccallum',
        RT = (R+sqrt(R.^2+4))/2;
    otherwise
        error( sprintf( 'Unknown (inverse) transform function: ''%s''', T ) );
    end
else
    error( sprintf( 'Unknown option: %s', I ) );
end

% EOF