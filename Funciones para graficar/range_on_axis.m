function [x1,x2,y1,y2,z1,z2] = range_on_axis(ax,varargin)
%RANGE_ON_AXIS   Axis data range
%   Returns the axis limits to the range of the data, or the data
%   amplitude (x2-x1, y2-y1 and z2-z1).
%   As varargin you can use pairs of PropName,PropValue, so that only
%   objects with such properties will be used.
%
%   Syntax:
%      [AMPX,AMPY,AMPZ] = RANGE_ON_AXIS(AXIS,VARARGIN)
%      [X1,X2,Y1,Y2,Z1,Z2] = RANGE_ON_AXIS(AXIS,VARARGIN)
%
%   Inputs:
%      AXIS   Desired axis [ gca ]
%      VARARGIN:
%         PropName,PropValue, Properties of the objects to be used
%
%   Outputs:
%      X1, X2, Y1, Y2, Z1, Z2   x, y and z data range
%      AMPX, AMPY, AMPZ         x, y and z data amplitude
%
%   Examples:
%      figure
%      plot(1:10); hold on
%      p=plot([-1 0 1],[-1 0 0]);
%      set(p,'linewidth',5);
%      [ampx,ampy,ampz] = range_on_axis;
%      [x1,x2,y1,y2,z1,z2] = range_on_axis(gca,'color','b','linewidth',5);
%
%   MMA 8-2005, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

%   16-12-2005 - Added function isprop, not present in Matlab R<13

if nargin == 0
  ax = gca;
end

if mod(length(varargin),2) ~= 0
  disp('# invalid parameter/value pair arguments');
  return
end

x1 = []; x2 = [];
y1 = []; y2 = [];
z1 = []; z2 = [];
obj_all = get(ax,'children');
% select objects to use:
if isempty(varargin)
  obj = obj_all;
else
  obj = findobj(obj_all,varargin{:});
end

Obj=[];
cont=0;
for i=1:length(obj)
 if isprop(obj(i),'XData') & isprop(obj(i),'YData') & isprop(obj(i),'ZData')
    cont=cont+1;
    Obj(cont) = obj(i);
  end
end

for i=1:length(Obj)
  xdata = get(Obj(i),'xdata');
  ydata = get(Obj(i),'ydata');
  zdata = get(Obj(i),'zdata');
  x1_ = min(reshape(xdata,1,prod(size(xdata))));
  x2_ = max(reshape(xdata,1,prod(size(xdata))));
  y1_ = min(reshape(ydata,1,prod(size(ydata))));
  y2_ = max(reshape(ydata,1,prod(size(ydata))));
  z1_ = min(reshape(zdata,1,prod(size(zdata))));
  z2_ = max(reshape(zdata,1,prod(size(zdata))));

  if i==1
    x1 = x1_; x2 = x2_;
    y1 = y1_; y2 = y2_;
    z1 = z1_; z2 = z2_;
  else
    x1 = min([x1 x1_]); x2 = max([x2 x2_]);
    y1 = min([y1 y1_]); y2 = max([y2 y2_]);
    z1 = min([z1 z1_]); z2 = max([z2 z2_]);
  end
end
if isempty(x1) x1=0; end, if isempty(x2) x2=0; end
if isempty(y1) y1=0; end, if isempty(y2) y2=0; end
if isempty(z1) z1=0; end, if isempty(z2) z2=0; end
if isequal(x1,x2), x1=x1-1; x2=x2+1; end
if isequal(y1,y2), y1=y1-1; y2=y2+1; end
if isequal(z1,z2), z1=z1-1; z2=z2+1; end

ampx=x2-x1;
ampy=y2-y1;
ampz=z2-z1;

if nargout == 0
  out.x1 = x1;
  out.x2 = x2;
  out.y1 = y1;
  out.y2 = y2;
  out.z1 = z1;
  out.z2 = z2;
  out.ampx = ampx;
  out.ampy = ampy;
  out.ampz = ampz;
  disp(struct(out));
elseif nargout == 3
  x1 = ampx;
  x2 = ampy;
  y1 = ampz;
end

function res=isprop(handle,prop)
%ISPROP   Check handle property
%
%   Syntax:
%      RES = ISPROP(HANDLE,PROP)
%
%   Inputs:
%      HANDLE   Handle to check
%      PROP     Property to find
%
%   Output:
%      RES   0 or 1
%
%   Example:
%      p=plot(1:10);
%      res=isprop(p,'Color')
%
%   MMA 13-8-2003, martinho@fis.ua.pt
%
%   Department of physics
%   University of Aveiro

res=0;
if ~ishandle(handle)
  return
end
s=get(handle);
if isfield(s,prop)
  res=1;
end
