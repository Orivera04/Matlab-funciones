function tf=mmisvect(x,rc)
%MMISVECT(X) True for Vectors. (MM)
% MMISVECT(X) returns logical TRUE if X is a 2D array having one
% row and nonzero columns or one column and nonzero rows.
%
% MMISVECT(X,'row') returns logical TRUE if X is a 2D ROW array.
% MMISVECT(X,'col') returns logical TRUE if X is a 2D COLUMN array.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 3/2/99, 1/17/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

sx=size(x);
tf= ndims(x)==2 & prod(sx)==length(x);
if tf & nargin==2 & ischar(rc) & length(rc)>0
   switch lower(rc(1))
   case 'r'
      tf=(sx(1)==1);
   case 'c'
      tf=(sx(2)==1);
   otherwise
      error('''Row'' or ''Col'' Required for Second Argument.')
   end
end