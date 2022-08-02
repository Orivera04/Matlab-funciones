function G = GAsignature(Sign1,Sign2,Sign3)
%GAsignature: Changes the signature of the space.
%Also returns the signature as a row matrix
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
persistent GAsignature3;
persistent GAsignature2;
persistent GAsignature1;
if nargin == 3
   GAsignature3=Sign3;
   GAsignature2=Sign2;
   GAsignature1=Sign1;
end
G=[prod(GAsignature1),prod(GAsignature2),prod(GAsignature3)];
