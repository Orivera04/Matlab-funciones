function figh=previewcand(des,dims,maxpoints,varargin);
% PREVIEWCAND   Create an object to preview the candidate space
%
% H=PREVIEWCAND(D,NDIMS,MAXPOINTS) opens a figure window and creates
% an object for viewing the candidate points using NDIMS dimensions.
% MAXPOINTS is the maximum number of points that should be plotted;
% if there are mode candidate points than this then the set is sub-
% sampled using an appropriate prime step.  The handle to the preview
% figure is returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:21 $


if nargin>3
   %update mechanism
   if strcmp(varargin{1},'update')
      figh=varargin{2};
      obj=get(figh,'userdata');
      i_updategraph(obj,des,dims,maxpoints);
      varargin(1:2)=[];
      return
   end
end


switch dims
case 1
   func='mvgraph1d';
   ttl='1D Projection of Candidate Set';
case 2
   func='mvgraph2d';
   ttl='2D Projection of Candidate Set';
case 3
   func='mvgraph3d';
   ttl='3D Projection of Candidate Set';
case 4
   func='mvgraph4d';
   ttl='4D Projection of Candidate Set';
end

% create new figure
figh=xregfigure('name',ttl,...
   'visible','off',...
   'renderer','zbuffer');
if length(varargin)
   set(figh,varargin{:});
end
figsz=get(figh,'position');
obj=feval(func,figh,'position',[10 10 figsz(3)-20 figsz(4)-20],'frame','off','factorselection','exclusive');

i_updategraph(obj,des,dims,maxpoints);


pnl=xregpanellayout(figh,...
   'center',obj,...
   'innerborder',[0 0 0 0],...
   'packstatus','off');
figh.LayoutManager=pnl;
figh.userdata=obj;
set(pnl,'packstatus','on');
set(figh,'visible','on');
return



function i_updategraph(obj,des,dims,maxpoints)

% get data for object
nc=ncand(des);
if nc>maxpoints
   % need to subsample
   n=nc./maxpoints;
   m=floor(n);
   go=1;
   while go
      % find first prime >= n
      m=m+20;
      p=primes(m);
      p=p(p>=n);
      if ~isempty(p)
         go=0;
      end
   end
   p=p(1);
   cand=indexcand(des,1:p:nc);   
else
   cand=indexcand(des,1:nc);
end

cand=invcode(model(des),cand);

%get limits
lims=limits(des.candset);
lims=invcode(model(des),lims')';
lims=num2cell(lims,2)';

set(obj,'factors',get(model(des),'symbol'),...
   'limits',lims,...
   'data',cand);

