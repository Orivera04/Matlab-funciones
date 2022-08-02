function  [xz,y,z] = banana(arg1,arg2);
%BANANA  A sample function of two variables.
%   BANANA is a function of two variables: Rosenblatt's "banana" function, 
%   which is useful for demonstrating
%   MESH, SURF, PCOLOR, CONTOUR, etc.
%   There are several variants of the calling sequence:
%
%       Z = BANANA;
%       Z = BANANA(N);
%       Z = BANANA(V);
%       Z = BANANA(X,Y);
%
%       BANANA;
%       BANANA(N);
%       BANANA(V);
%       BANANA(X,Y);
%
%       [X,Y,Z] = BANANA;
%       [X,Y,Z] = BANANA(N);
%       [X,Y,Z] = BANANA(V);
%
%   The first variant produces a 49-by-49 matrix.
%   The second variant produces an N-by-N matrix.
%   The third variant produces an N-by-N matrix where N = length(V).
%   The fourth variant evaluates the function at the given X and Y,
%   which must be the same size.  The resulting Z is also that size.
%
%   The next four variants, with no output arguments, do a SURF
%   plot of the result.
%
%   The last three variants also produce two matrices, X and Y, for
%   use in commands such as PCOLOR(X,Y,Z) or SURF(X,Y,Z,DEL2(Z)).
%
%   If not given as input, the underlying matrices X and Y are
%       [X,Y] = MESHGRID(V,V) 
%   where V is a given vector, or V is a vector of length N with
%   elements equally spaced from -3 to 3.  If no input argument is
%   given, the default N is 49.

% Modified version of peaks.m by A. Knight, February 1999.  Original peaks.m by:
%   CBM, 2-1-92, 8-11-92, 4-30-94.
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.6 $  $Date: 1997/11/21 23:26:44 $

if nargin == 0
    [x,y] = meshgrid(linspace(-2,2,49));
elseif nargin == 1
    if length(arg1) == 1
        [x,y] = meshgrid(linspace(-2,2,arg1));
    else
        [x,y] = meshgrid(arg1,arg1);     
    end
else
   [x,y] = meshgrid(arg1,arg2);
   %x = arg1; y = arg2;
end

z = 100*(y - x.^2).^2 + (1 - x).^2;;

if nargout > 1
    xz = x;
elseif nargout == 1
    xz = z;
else
   % Self demonstration
   clf
    disp(' ')
    disp('z =  z = 100*(y - x.^2).^2 + (1 - x).^2')
    disp(' ')
    hmesh = mesh(x,y,z);
    set(hmesh,'edgecolor',[.5 .5 .5],...
       'meshstyle','row');
    top = max(max(z));
    hold on
    v = logspace(log10(top) - 4,log10(top),20);
    contour3(x,y,z,v,'k')
    axis([min(min(x)) max(max(x)) min(min(y)) max(max(y)) ...
          min(min(z)) top])
    xlabel('x'), ylabel('y'), title('Rosenblatt''s banana function')
    view(64,66)   
 end
