function b=blade(a)
% blade(a) : return a blade made from the largest portion of a multivector.
%
%See also gable, GAZ, gazv, grade.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
s(1) = abs(a.m(1));
s(2) = sqrt(sum(abs(a.m(2:4))));
s(3) = sqrt(sum(abs(a.m(5:7))));
s(4) = abs(a.m(8));
if s(1)>s(2) & s(1)>s(3) & s(1)>s(4)
  b = a.m(1);
elseif s(2)>s(3) & s(2)>s(4)
  b = GA([0; a.m(2); a.m(3); a.m(4); 0; 0; 0; 0]);
elseif s(3)>s(4)
  b = GA([0; 0; 0; 0; a.m(5); a.m(6); a.m(7); 0]);
else
  b = GA([0; 0; 0; 0; 0; 0; 0; a.m(8)]);
end
