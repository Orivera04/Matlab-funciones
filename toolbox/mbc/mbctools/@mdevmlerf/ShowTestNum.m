function txt= ShowTestNum(mdev,ax,NoOutliers,X,Y);
% MODELDEV/SHOWTESTNUM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/02/09 08:05:31 $




if nargin==2 
   NoOutliers=1;
end


lh=findobj(ax,'tag','main line');
tnvis= get(ax,'visible');
lh=lh(1);
xdata=get(lh,'xdata');
ydata=get(lh,'ydata');

if nargin<4
   [X,Y]= getdata(mdev,'FIT');
end
%% X = {Xloc,Xglob}  Xloc has our local factors for all sweeps
Xloc=X{1};

tn= testnum(Xloc);

if length(xdata)~=length(tn) 
   % probably doing one-stage model with sweep data 
   ts= tsizes(Xloc);
   t= cell(length(tn),1);
   for i=1:length(tn)
      t{i}= tn(i)*ones(ts(i),1);
   end
   tn= cat(1,t{:});
end   
   
p= Parent(mdev);
% mle diagnostic plots uses predmode==0
[X,Y,dOk]= FitData(mdev);
tn= testnum(X);
tn=tn(find(dOk));

p= Parent(mdev);
[Notes,cols]= SweepNotes(p.info);
cols= cols(dOk);
txt= zeros(length(tn),1);
tstr= mbcnum2str(tn,20,'%20.12g');
for i=1:length(xdata)
   txt(i)=text(xdata(i),ydata(i),tstr(i,:),...
      'parent',ax(1),...
      'fontsize',8,...
      'color',cols{i},...
      'horizontalalignment','right',...
      'hittest','off',...
      'verticalAlignment','bottom',...
      'Tag','TestNumText',...
		'visible',tnvis,...
      'clipping','off');
end
