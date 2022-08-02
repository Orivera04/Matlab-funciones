function b = GAisa(G,t)
% GAisa(G,t): Return 1 if G is of type t, 0 otherwise
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if strcmp(t,'double') 
    b = 1;
elseif G==0
    b = 1;
else
    b = 0;
end
