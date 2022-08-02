function FFF=integral(f,x,y,z)
%INTEGRAL  Integral of a function matrix.
%   FP = INTEGRAL(F,X[,Y[,Z]]), where FP is the primitive function
%   of F (3D matrix from meshgrid) and X, Y and Z are vectors
%   representing each of the axis to integrate along
%   (as in meshgrid(X,Y,Z)). No integration along an axis is
%   represented by an empty array in that place.
%   N.B. Constant terms are likely to be added to FP while integrating.
%
%   See also TRAPZ.

% Copyright (c) 2001-08-25, B. Rasmus Anthin.

error(nargchk(2,4,nargin))
if ~isempty(x)
   for k=1:size(f,3)
      for i=1:size(f,1)
         for j=2:size(f,2)
            F(i,j,k)=trapz(x(1:j),f(i,1:j,k));
         end
      end
   end
else
   F=f;
end
if nargin>2 & ~isempty(y)
   for k=1:size(f,3)
      for j=1:size(f,2)
         for i=2:size(f,1)
            FF(i,j,k)=trapz(y(1:i),F(1:i,j,k));
         end
      end
   end
else
   FF=F;
end
if nargin>3 & ~isempty(z)
   for i=1:size(f,1)
      for j=1:size(f,2)
         for k=2:size(f,3)
            FFF(i,j,k)=trapz(z(1:k),FF(i,j,1:k));
         end
      end
   end
else
   FFF=FF;
end