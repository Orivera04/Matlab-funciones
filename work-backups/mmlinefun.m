function varargout=mmlinefun(fun,varargin)
%MMLINEFUN Functions on Line Segments. (MM)
% [OutArgs]=MMLINEFUN(FUN,InArgs) performs the function FUN on
% the list of input arguments InArgs, producing a list of output
% arguments in OutArgs.
%
% Y=MMLINEFUN('Evaluate',LineIn,X) evaluates LineIn at the points in X
% returning results in Y, which is the same size as X. LineIn is one of
% the argument formats shown below:
% [M,b]         Slope, Y-intercept format:  y = M*x + b
% [M,X1,Y1]     Slope, One-point format: y-Y1 = M*(x - X1)
% [X1,Y1,X2,Y2] Two Point format:        y-Y1 = M*(x - X1)
%                                         where M = (Y2-Y1)/(X2-X1)
% For example: y=MMLINEFUN('Evaluate',[M,X1,Y1],X) evaluates the line
% Y-Y1 = M*(X - X1) returning Y. Note that LineIn is One argument.
%
% [Xi,Yi]=MMLINEFUN('Intersect',Line1In,Line2In) finds the points of
% intersection between Line1In and Line2In. Line1In and Line2In share
% one of the argument formats shown above. Xi and Yi are empty if the
% two lines are parallel.
% For example: [Xi,Yi]=MMLINEFUN('Intersect',[M1,b1],[M2,b2]) finds the 
% intersection of the lines y = M1*x + b1 and y = M2*x + b2
%
% [D,Dx,Dy]=MMLINEFUN('Distance',LineIn,Xp,Yp) finds the perpendicular
% or shortest distance between the points Xp,Yp and the line denoted
% LineIn, described by one of the argument formats shown above.
% Dx = Xp - Xintersect so Dx>0 if Xp is to the right of the intercept.
% Dy = Yp - Yintersect so Dy>0 if Yp is above the intercept.
% D=sqrt(Dx.^2 + Dy.^2) = perpendicular distance from Xp,Yp to line.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 2/1/00, 2/8/00
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<3 | ~ischar(fun) | isempty(fun)
   error('First Argument Must be a String.')
end
switch lower(fun(1))
case 'e' % Evaluate Evaluate Evaluate Evaluate Evaluate Evaluate Evaluate
   [line,x]=deal(varagin{:});
   ltype=length(line);
   if ltype==2 % y = M*x + b
      [m,b]=local_deal(line);
      varargout{1}=m*x+b;
   elseif ltype==3 % y-Y1 = M*(x - X1)
      [m,x1,y1]=local_deal(line);
      varargout{1}=m*(x-x1)+y1;
   elseif ltype==4 % y-Y1 = (Y2-Y1)/(X2-X1)*(x - X1)
      [x1,y1,x2,y2]=local_deal(line)
      varargout{1}=(y2-y1)/(x2-x1)*(x-x1) + y1;
   else
      error('Unknown Line Type Specified.')
   end
case 'i' % Intersect Intersect Intersect Intersect Intersect Intersect
   [line1,line2]=deal(varargin{:});
   ltype=length(line1);
   if ltype~=length(line2) | ltype<2 | ltype>4
      error('Unknown Line Type Specified.')
   end
   if ltype==2 % y = M*x + b
      [m1,b1]=local_deal(line1);
      [m2,b2]=local_deal(line2);
      if m1==m2 | isinf(m1) | isinf(m2)
         varargout{1}=[];
         varargout{2}=[];
      else
         xi=(b2-b1)/(m1-m2);
         varargout{1}=xi;
         varargout{2}=m1*xi+b1;
      end
   elseif ltype==3 % y-Y1 = M*(x - X1)
      [m1,x1,y1]=local_deal(line1);
      [m2,x2,y2]=local_deal(line2);
      if (isinf(m1)&isinf(m2)) | ...   % both lines are vertical
            (abs(m1-m2)<eps)             % lines are parallel 
         varargout{1}=[];
         varargout{2}=[];
      elseif isinf(m1)  % line 1 is vertical
         varargout{1}=x1;
         varargout{2}=m2*(x1-x2)+y2;
      elseif isinf(m2)  % line 2 is vertical
         varargout{1}=x2;
         varargout{2}=m1*(x2-x1)+y1;
      else  % general case
         xi=(m1*x1-y1-m2*x2-y2)/(m1-m2);
         varargout{1}=xi;
         varargout{2}=m1*(xi-x1)+y1;
      end
   elseif ltype==4 % y-Y1 = (Y2-Y1)/(X2-X1)*(x - X1)
      [x11,y11,x12,y12]=local_deal(line1);
      [x21,y21,x22,y22]=local_deal(line2);
      if abs(x11-x12)<eps % first line is vertical
         m1=(sign(y12-y11)+y12==y11)*inf;
      else
         m1=(y12-y11)/(x12-x11);
      end
      if abs(x22-x21)<eps % second line is vertical
         m2=(sign(y22-y21)+y22==y21)*inf;
      else
         m2=(y22-y21)/(x22-x21);
      end
      [xi,yi]=mmlinefun('i',[m1,x11,y11],[m2,x21,y21]);
      varargout{1}=xi;
      varargout{2}=yi;
   end
case 'd' % Distance Distance Distance Distance Distance Distance Distance
   [line,xp,yp]=deal(varargin{:});
   ltype=length(line);
   if ltype==2  % y = M*x + b
      [m,b]=local_deal(line);
      if m==0
         dx=0;
         dy=yp-b;
      elseif isinf(m)
         dy=0;
         dx=xp;
      else
         xi=(xp+(yp-b)*m)/(1+m^2);
         yi=m*xi+b;
         dx=xp-xi;
         dy=yp-yi;
      end      
   elseif ltype==3 % y-Y1 = M*(x - X1)
      [m,x1,y1]=local_deal(line);
      if m==0
         dx=0;
         dy=yp-y1;
      elseif isinf(m)
         dy=0;
         dx=xp-x1;
      else
         xi=(xp+m^2*x1+m*(yp-y1))/(1+m^2);
         yi=m*(xi-x1)+y1;
         dx=xp-xi;
         dy=yp-yi;
      end      
   elseif ltype==4 % y-Y1 = (Y2-Y1)/(X2-X1)*(x - X1)
      [x1,y1,x2,y2]=local_deal(line);
      tol=10*eps;
      if abs(y2-y1)<tol % horizontal line
         dx=0;
         dy=yp-y1;
      elseif abs(x2-x1)<tol;   % vertical line
         dy=0;
         dx=xp-x1;
      else  % general line
         m=(y2-y1)/(x2-x1);
         xi=(m^2*x1 + m*(yp-y1) + xp) ./ (1 + m^2);
         yi=m*(xi-x1)+y1;
         dx=xp-xi;
         dy=yp-yi;
      end
   else
      error('Unknown Line Type Specified.')
   end
   varargout{1}=sqrt(dx.^2 + dy.^2);
   varargout{2}=dx;
   varargout{3}=dy;
otherwise
   error('Unknown Function Requested.')
end
%----------------------------------------------------------
function varargout=local_deal(linein)
for i=1:nargout
   varargout{i}=linein(i);
end