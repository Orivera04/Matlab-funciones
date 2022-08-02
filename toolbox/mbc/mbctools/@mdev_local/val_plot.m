function ht= val_plot(mdev,Xs,Ys,AxHand,ht);
%
% ht= val_plot(mdev,SNo,AxHand,X,Y);
%  Inputs
%     mdev    mdev_local object
%     Xs       X data
%     Ys       Y data
%     AxHand  axes handle(s) for display (1=plot,2=optional info)
%     ht      height variable (for text)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:21 $

m= model(mdev);


XG=smean( Xs(:,nlfactors(TS)+1:end) );

% call model/validate to do fit and draw response
[h,Lpred,Lfpred]= plot(m,{XG,Xs},Ys,AxHand(1));

% plot data
plot(Xs,Ys,'bo','bd','parent',AxHand(1));

if length(AxHand)>1
   
   % calculate and display s
   rp=(double(Ys)-Lpred{1});
   rp= rp(isfinite(rp));
   sp = sqrt( sum(rp.^2)/length(rp,1) );
   
   dispstr= sprintf('%10.3g ',sp);
   th=text('units','norm','pos',[0.95,ht],...
      'parent',AxHand(2),...
      'string',dispstr,....
      'FontName','Lucida Console',...
      'Color',get(h(ModNo),'Color'),...
      'clipping','on',...
      'Interpreter','none',...
      'horizon','right','vert','top');        
   Textent= get(th,'extent');
   ht= ht-Textent(4);
end
