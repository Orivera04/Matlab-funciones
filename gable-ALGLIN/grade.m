function r=grade(A,n)
%grade(A,n): return the part of an object of a particular grade.
% Return the part of M of grade n.
% If n is omitted, return the grade of M (-1 if M is of mixed grade) 
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

if nargin == 1
   if A == 0 
      r=-1;
   else
      r=0;
   end
else
   if n==0
      r=A;
   else
      r=0;
   end
end
