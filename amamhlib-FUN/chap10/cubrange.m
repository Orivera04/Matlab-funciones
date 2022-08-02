function range=cubrange(xyz,ovrsiz)
%
% range=cubrange(xyz,ovrsiz)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines limits for a square 
% or cube shaped region for plotting data values 
% in the columns of array xyz to an undistorted 
% scale
%
% xyz    - a matrix of the form [x,y] or [x,y,z]
%          where x,y,z are vectors of coordinate
%          points
% ovrsiz - a scale factor for increasing the
%          window size. This parameter is set to
%          one if only one input is given.
%
% range  - a vector used by function axis to set
%          window limits to plot x,y,z points
%          undistorted. This vector has the form
%          [xmin,xmax,ymin,ymax] when xyz has
%          only two columns or the form 
%          [xmin,xmax,ymin,ymax,zmin,zmax]
%          when xyz has three columns.
%
% User m functions called:  none
%----------------------------------------------

if nargin==1, ovrsiz=1; end
pmin=min(xyz); pmax=max(xyz); pm=(pmin+pmax)/2;
pd=max(ovrsiz/2*(pmax-pmin));
if length(pmin)==2
  range=pm([1,1,2,2])+pd*[-1,1,-1,1];
else
  range=pm([1 1 2 2 3 3])+pd*[-1,1,-1,1,-1,1];
end
