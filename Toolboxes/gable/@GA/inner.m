function r = inner(A,B)
%inner(A,B): compute the inner product of A and B.
% There are multiple inner products; choose the one
% you want with GAitype
%
% See also gable, innerH, innerS, and contraction.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

t = GAitype;
if t==0
  r = contraction(A,B);
elseif t==1
  r = innerH(A,B);
elseif t==2
  r = innerS(A,B);
else
  error('Unknown inner type');
end
