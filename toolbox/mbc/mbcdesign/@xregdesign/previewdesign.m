function figh=previewdesign(des,dims,varargin);
% PREVIEWDESIGN   Create an object to preview the design
%
% H=PREVIEWDESIGN(D,NDIMS) opens a figure window and creates
% an object for viewing the design points using NDIMS dimensions.
% The handle to the preview figure is returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:07:22 $

% Created 12/1/2000


% create new figure
figh=xregfigure('units','pixels',...
   'toolbar','none',...
   'menubar','none',...
   'numbertitle','off',...
   'name','Design - Factor Levels',...
   'visible','off',...
   'renderer','zbuffer',...
   'handlevisibility','off');

figsz=get(figh,'position');

switch dims
case 1
   func='mvgraph1d';
case 2
   func='mvgraph2d';
case 3
   func='mvgraph3d';
case 4
   func='mvgraph4d';
end

obj=feval(func,figh,'position',[10 10 figsz(3)-20 figsz(4)-20]);

% get data for object
cand=factorsettings(des);
cand=invcode(model(des),cand);

%get limits

set(obj,'data',cand,...
   'factors',factors(des),...
   'factorselection','exclusive',...
   'limits',designlimits(des,'natural'));

if nargin>2
   % pass on arguments to figure
   set(figh,varargin{:});
end

figh.LayoutManager=xreglayerlayout(figh,'elements',{obj},'border',[10 10 10 10]);
set(figh,'visible','on');

return
