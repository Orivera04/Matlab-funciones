function h=rmse_plot(mdev,Type,XVar,Ax,ind);
% MDEV_LOCAL/RMSE_PLOT plot local rmse

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:05:06 $



SNo=[];
switch lower(Type)
case 'local'
   % local
   df= mdev.MLE.df;
   RMSE= zeros(size(df));
   RMSE(df>0)= sqrt(mdev.MLE.SSE_nat(df>0)./df(df>0));
   RMSE(df<=0)= NaN;   
   s= statistics(mdev);
   Pooled_RMSE= s(1);

   if nargin==5
      SNo= ind;
   end
case 'pred'
   % predicted
   RMSE= mdev.TSstatistics.RMSE(:,ind);
   chead=colhead(mdev);
   if mdev.MLE.Validate 
      % for mle validation
      Pooled_RMSE= mdev.TSstatistics.Summary(ind,2);
   else
      % for ts validation
      twostageRMSEindex = 2;
      Pooled_RMSE= mdev.TSstatistics.Summary(ind,twostageRMSEindex);
   end

case 'press'
   % PRESS
   RMSE= mdev.TSstatistics.RPRESS(:,ind);
   PRESSRMSEindex = 3;
   Pooled_RMSE= mdev.TSstatistics.Summary(ind,PRESSRMSEindex);

end

ch= children(mdev);

if XVar==1
   x= 1:length(RMSE);
   Xname= 'Obs. Number';
else
   x= ch(1).getdata('X');
   Xind=XVar-1;
   if Xind<=size(x,2)
      Xname= get(ch(1).model,'symbol');
      Xname= Xname{Xind};
      x= double(x(:,Xind));
   else   
      XVar= XVar-size(x,2)-1;
      x= double(ch(XVar).getdata('Y'));
      Xname= ch(XVar).name;
   end
end

h= plot(x,RMSE,'.',...
   'tag','main line','parent',Ax);

if ~isempty(SNo);
   line('XData',x(SNo),'YData',RMSE(SNo),...
      'color','r',...
      'Marker','o',...
      'parent',Ax);
end

np= get(Ax,'nextplot');
set(Ax,'nextplot','add')
plot(get(Ax,'xlim')',[Pooled_RMSE Pooled_RMSE]',...
   'parent',Ax);

set(Ax,'xgrid','on','ygrid','on','nextplot',np)

set(get(Ax,'Xlabel'),'string',Xname,'interpreter','none')
set(get(Ax,'Ylabel'),'string','RMSE')
