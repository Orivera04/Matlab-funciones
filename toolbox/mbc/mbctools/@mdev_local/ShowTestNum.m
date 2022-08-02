function txt= ShowTestNum(mdev,ax,NoOutliers,X,Y);
% MODELDEV/SHOWTESTNUM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:04:12 $




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
   %% X = {Xloc,Xglob}  Xloc has our local factors for all sweeps
   Xloc=X{1};
   tn= testnum(Xloc);
   if length(xdata)==length(tn(mdev.FitOK))
      tn= tn(mdev.FitOK);
   end
else
   Xloc=X{1};
   tn= testnum(Xloc);
end



if length(xdata)~=length(tn) 
   % probably doing one-stage model with sweep data 
   ts= tsizes(Xloc);
   t= cell(length(tn),1);
   for i=1:length(tn)
      t{i}= tn(i)*ones(ts(i),1);
   end
   tn= cat(1,t{:});
end   
   

if NoOutliers
   % mle diagnostic plots uses predmode==0
   [Xg,Yrf,Sigma]= mledata(mdev,0,0);
   [Xgc,Yrf,W,dOk] = checkdata(mdev.TwoStage{1},Xg,Yrf,Sigma);
   tn= testnum(X{2});
   tn=tn(find(dOk));
end


txt= zeros(length(tn),1);
tstr= mbcnum2str(tn,20,'%20.12g');
for i=1:length(xdata)
   txt(i)=text(xdata(i),ydata(i),tstr(i,:),...
      'parent',ax(1),...
      'fontsize',8,...
		'visible',tnvis,...
      'horizontalalignment','right',...
      'hittest','off',...
      'verticalAlignment','bottom',...
      'Tag','TestNumText',...
      'clipping','off');
end
