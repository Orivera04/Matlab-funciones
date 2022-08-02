function true_in = constrain( c, X, in )
%CONSTRAIN  Constrain a list of points
%   CONSTRAIN(C,X,IN) is a uint8 logical vector indicating which points in 
%   X (N-by-nfactors) are within the constrained region. IN is a uint8 
%   logical vector indicating which points to constrain and which to 
%   ignore, i.e., which points are currently considered to be "in" the 
%   constrained region.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 06:57:28 $ 

% The original 'in' is required to get the output right. It is also the
% default output if all points are already outside or if the boolean
% constraint object has no constraints.
true_in = in; 

if ~any( in ),
    return
end

nc = length( c.Constraints ); % number of constraints
if nc == 0,
    return
end

% Only consider points that are already 'in'
X = X(in,:);
in = in(in);

switch lower( c.Op ),
    case 'none',
        if nc ~= 1,
            warning( 'Invalid boolean constraint object' );
        end
        in = constrain( c.Constraints{1}, X, in );
        
    case 'and',
        i = 1;
        while any( in ) && i <= nc,
            in(in) = constrain( c.Constraints{i}, X(in,:), in(in) );
            i = i + 1;
        end
        
    case 'or',
        out = in; % outside this constraint
        for i = 1:nc,
            out(out) = ~constrain( c.Constraints{i}, X(out,:), out(out) );
        end
        in = ~out;
        
    case 'xor',
        if nc ~= 2,
            warning( 'Invalid boolean constraint object' );
        end
        in = xor( ...
            constrain( c.Constraints{1}, X, in ), ...
            constrain( c.Constraints{2}, X, in ) );
    otherwise
        warning( 'Invalid boolean constraint object' );
end

% 'not' the constraints
in = xor( c.Not, in );

% Setup output
true_in(true_in) = in; 

% EOF
