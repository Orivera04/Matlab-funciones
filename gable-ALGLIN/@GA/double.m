function f = double(A)
%double(GA) : convert a GA object to a double.
%  Conversion can only happen if all non-scalar fields of GA are 0.
%
% See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
  if A.m(2)==0 & A.m(3) == 0 & A.m(4) == 0 & A.m(5) == 0 & A.m(6) == 0 & A.m(7) == 0 & A.m(8) == 0
    f = A.m(1);
  else
    error('Can only convert a scalar GA object to double.');
  end
