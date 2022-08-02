function u = unit(A)
%unit(A): return A scaled to be unit length
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if isGrade(A,0)
  u = unit(A.m(1));
elseif isGrade(A,1)
  s = sqrt(A.m(2)*A.m(2)+A.m(3)*A.m(3)+A.m(4)*A.m(4));
  u = A/s;
elseif isGrade(A,2)
  s = sqrt(A.m(5)*A.m(5)+A.m(6)*A.m(6)+A.m(7)*A.m(7));
  u = A/s;
elseif isGrade(A,3)
  u = A/abs(A.m(8));
else
  error('Unit can only be applied to blades.');
end
