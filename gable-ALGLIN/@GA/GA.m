function C = GA(m)
%GA(m): create a multivector from a matrix m.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if nargin == 0
    C.m = [0; 0; 0; 0; 0; 0; 0; 0];
    C = class(C, 'GA');
elseif isa(m, 'GA')
    C = m;
elseif isa(m, 'double');
    if size(m,1)==1 & size(m,2)==1 & isa(m, 'double');
	C.m = [m; 0; 0; 0; 0; 0; 0; 0];
	C = class(C, 'GA');
    else
	if size(m,1)==1 & size(m,2)==8
	    C.m = m';
	elseif size(m,1)==8 & size(m,2)==1
	    C.m = m;
	else
	    error('Bad GA argument array size');
	end
	C = class(C, 'GA');
    end
else
    error('Bad GA argument: must be double array');
end
