function [area,cx,cy] = polycenter(x,y,dim)
%POLYCENTER Area and centroid of polygon.
%   [AREA,CX,CY] = POLYCENTER(X,Y) returns the area and the centroid
%   coordinates of the polygon specified by the vertices in the vectors X
%   and Y. If X and Y are matrices of the same size, then POLYCENTER
%   returns the centroid and area of polygons defined by the columns X and
%   Y. If X and Y are arrays, POLYCENTER returns the centroid and area of
%   the polygons in the first non-singleton dimension of X and Y.
%
%   POLYCENTER is an extended version of POLYAREA.
%
%   The polygon edges must not intersect. If they do, POLYCENTER returns
%   the values of the difference between the clockwise encircled parts and
%   the counterclockwise ones. As in POLYAREA, the absolute value is used
%   for the area.
%
%   [AREA,CX,CY] = POLYCENTER(X,Y,DIM) returns the centroid and area of the
%   polygons specified by the vertices in the dimension DIM.
%
%   Example:
%       % Area and centroid of two ellipses:
%       t = linspace(-pi,pi);
%       a = [5;3]; b = [2;1];
%       x0 = [1;-1]; y0 = [-2;0];
%       x = a*cos(t)+repmat(x0,[1 100]); y = b*sin(t)+repmat(y0,[1 100]);
%       area1 = polyarea(x,y,2), [area2,cx,cy] = polycenter(x,y,2)
%       area3 = pi*a.*b
%
%   Damien Garcia, 08/2007, directly adapted from polyarea
%
%   See also POLYAREA.

if nargin==1 
  error('MATLAB:polycenter:NotEnoughInputs','Not enough inputs.'); 
end

if ~isequal(size(x),size(y)) 
  error('MATLAB:polycenter:XYSizeMismatch','X and Y must be the same size.'); 
end

if nargin==2
    [x,nshifts] = shiftdim(x);
    y = shiftdim(y);
elseif nargin==3
    perm = [dim:max(length(size(x)),dim) 1:dim-1];
    x = permute(x,perm);
    y = permute(y,perm);
end

siz = size(x);
if ~isempty(x)
    tmp = x(:,:).*y([2:siz(1) 1],:) - x([2:siz(1) 1],:).*y(:,:);
    area = reshape(sum(tmp),[1 siz(2:end)])/2;
    warning off MATLAB:divideByZero
    cx = reshape(sum((x(:,:)+x([2:siz(1) 1],:)).*tmp/6),[1 siz(2:end)])./area;
    cy = reshape(sum((y(:,:)+y([2:siz(1) 1],:)).*tmp/6),[1 siz(2:end)])./area;
    warning on MATLAB:divideByZero
    area = abs(area);
else
    area = sum(x); % SUM produces the right value for all empty cases
    cx = NaN(size(area));
    cy = cx;
end

if nargin==2
   area = shiftdim(area,-nshifts);
   cx = shiftdim(cx,-nshifts);
   cy = shiftdim(cy,-nshifts);
elseif nargin==3
    area = ipermute(area,perm);
    cx = ipermute(cx,perm);
    cy = ipermute(cy,perm);
end


