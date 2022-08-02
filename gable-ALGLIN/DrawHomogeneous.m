function r=DrawHomogeneous(e,A,c1,c2)
% DrawHomogeneous(e,A,c1,c2) - draw a simplex for the flat A.
%  This draws the tangent blade at a position given by the perpendicular support vector.
%  e: the special vector in homogeneous coordinates (typically e3)
%  A: the homogeneous blade
%  c1 is the color of the supporting vectors of the simplex 
%  c2 is the color of the simplex 
%  c1 and c2 are optional, although c1 must be specified if c2 is used
%     If c1=='n', then the vectors supporting the simplex are not drawn.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
di = GAZ(inner(e,A));
if di==0
   error('This blade resides at infinity and cannot be drawn');
end
po = GAZ(inner(e,e^A)/di);

if (grade(GA(po))~=1 & po ~=0)
   error('Need a vector to indicate position');
else
if GAZ(contraction(e,di))~=0
   error('The tangent blade is not perpendicular to the homogeneous dimension!');
else
   if grade(GA(di))==-1
      error('No flat to draw');
   end
   if grade(GA(di))==0
      DrawSimplex({e+po},c1,c2);   % point result
   end
   if grade(GA(di))==1
      DrawSimplex({e+po,e+po+di},c1,c2);   % line result
   end
   if grade(GA(di))==2
      if po ~= 0
         DrawSimplex({e,e+po,e+1/po*di},c1,c2);       % plane result
      else 
         if GAZ(e) ~= e1
             DrawSimplex({e,e+e1,e+1/e1*di},c1,c2);       % plane result 
         else
             DrawSimplex({e,e+e2,e+1/e2*di},c1,c2);       % plane result 
         end
      end
   end
   if grade(GA(di)) >2
      error('Highest permissible order of tangent blade is 2');
   end
end
end
