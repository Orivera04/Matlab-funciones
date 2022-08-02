function z=lineintegral(x,y,u,v,c)
%LINEINTRGAL Line Integral in a 2D Vector Field.
% LINEINTRGAL(X,Y,U,V,C) computes the line integral
%       /
%       |(U*dx + V*dy)
%       /
% along the lines given in cell array C.
%
% X and Y define the coordinates of a rectangular grid over which
% U and V are defined. X and Y must be monotonic and 2D plaid as
% produced by MESHGRID. X, Y, U, and V must all be the same size.
%
% C is a cell array where each cell contains an N-by-2 array of values
% defining an integration path. C{k}(:,1) contains the x-axis data and
% C{k}(:,2) contains the y-axis data defining points on the k-th line.
% The output of STREAM2 fits this cell array format.
%
% The output is a numerical array of size(C) containing the line integrals,
% with the k-th array element being the line integral of the k-th line.
%
% Because the lines are composed of piecewise-connected line segments,
% the trapezoidal integration algorithm is used.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% MasteringMatlab@yahoo.com
% Mastering MATLAB 7
% 2005-06-26

if nargin~=5
   error('Five Input Arguments Required.')
end
if ~isequal(size(x),size(y),size(u),size(v))
   error('X,Y,U, and V Must be the Same Size.')
end
if ~iscell(c)
   error('C Must be a Cell Array Containing Lines.')
end
csiz=size(c);
c=c(:);
z=zeros(csiz);
for k=1:length(c)
   xy=c{k};
   xysiz=size(xy);
   if min(xysiz)<2
      warning('Line #%d Has Too Few Points.',k)
      continue
   end
   if length(xysiz)>2 || xysiz(2)~=2
      error('Cells in C Must Contain N-by-2 Arrays.')
   end
   xdata=xy(:,1);
   ydata=xy(:,2);
   udata=interp2(x,y,u,xdata,ydata);
   vdata=interp2(x,y,v,xdata,ydata);
   outside=isnan(udata)|isnan(vdata);
   if any(outside)
      warning('Line #%d Contains Data Outside Range of X and Y.',k)
      udata(outside)=[];
      vdata(outside)=[];
      xdata(outside)=[];
      ydata(outside)=[];
   end
   dx=diff(xdata);
   dy=diff(ydata);
   dsu=(udata(1:end-1)+udata(2:end)).';
   dsv=(vdata(1:end-1)+vdata(2:end)).';
   z(k)=(dsu*dx + dsv*dy)/2;
end