function txt= ShowTestNum(mdev,ax,NoOutliers,X,Y);
% MODELDEV/SHOWTESTNUM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.4 $  $Date: 2004/04/04 03:31:46 $

if nargin==2 
   NoOutliers=1;
end


lh=findobj(ax,'tag','main line');
if isempty(lh) %% nothing to plot
   txt=[];
   return
end

tnvis= get(ax,'visible');

lh=lh(1);
xdata=get(lh,'xdata');
ydata=get(lh,'ydata');

if nargin<4
   [X,Y]= getdata(mdev,'FIT');
end
%% X = {Xglob} the sweepset of sweep means
X1= X{1};
X=X{end};
tn= testnum(X);
cols= num2cell(zeros(length(tn),3),2);
if length(xdata )==size(X1,1) & size(X1,3)==length(tn)
   % probably doing one-stage model with sweep data 
   ts= tsizes(X1);
   t= cell(length(tn),1);
   for i=1:length(tn)
      t{i}= tn(i)*ones(ts(i),1);
   end
   tn= cat(1,t{:});
   cols= num2cell(zeros(length(tn),3),2);
elseif isa(Y,'sweepset') & ~NoOutliers
   tn= testnum(Y);
else
   % find if this is a global model
   p= Parent(mdev);
   while p~=0 & ~isa(p.info,'mdev_local');
      p= p.Parent;
   end
   if p~=0 & isa(p.info,'mdev_local')
      % find where there are sweep notes
      [Notes,cols]= SweepNotes(p.info);
   end
end

if NoOutliers
   % Outlier NaNs already removed from data
   % need to remove from tn anc cols as well
   ok= isfinite(double(Y));
   tn=tn(ok);
   cols=cols(ok);
end
if length(xdata)~=length(tn)
   return
end

txt= zeros(length(tn),1);
tstr= mbcnum2str(tn,20,'%20.12g');
for i=1:length(xdata)
      
   txt(i)=text(xdata(i),ydata(i),tstr(i,:),...
      'parent',ax(1),...
      'fontsize',8,...
      'col',cols{i},...
      'horizontalalignment','right',...
      'hittest','off',...
      'verticalAlignment','bottom',...
      'Tag','TestNumText',...
		'visible',tnvis,...
      'clipping','off');
end

% check if we have to show testnumbers for bad data
lh =findobj(ax,'tag','BDPts');
if ~isempty(lh)
   [bdx,bdy,tn,bdind] = getoutliers(mdev);
   bdx= get(lh,'xdata');
   bdy= get(lh,'ydata');
	bdok= isfinite(bdy);
	tn= tn(bdok);
	bdind= bdind(bdok);
   for i=1:length(tn)
      text(bdx(i),bdy(i),num2str(tn(i)),...
         'parent',ax(1),...
         'fontsize',8,...
         'color',[0 0 1],...
         'horizontalalignment','right',...
         'hittest','off',...
         'verticalAlignment','bottom',...
			'visible',tnvis,...
         'Tag','TestNumText',...
         'clipping','off');
   end		
end
