function r=GAitype(T)
%GAitype(T): get or set the type of inner product.
% 0 : contraction (default)
% 1 : Hestenes
% 2 : Hestenes modified for scalars
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

persistent type;
if nargin == 1
  type=T;
end
r = sum(type);
