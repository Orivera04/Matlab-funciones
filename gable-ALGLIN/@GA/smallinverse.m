function C = smallinverse(m)
%smallinverse(m): finds the inverse of a multivector of the resricted form A+B*I3.
%
%See also gable, inverse.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

   S = prod(GAsignature);
   P = m.m(1)*m.m(1) + m.m(8)*m.m(8)*S;
   if P==0
      disp('smallinverse: This multivector does not have an inverse.');
      C=GA([0;0;0;0;0;0;0;0]);
   else
      C=GA([m.m(1)/P;0;0;0; 0;0;0; -m.m(8)/P]);
   end

