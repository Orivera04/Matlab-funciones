function [X,Y,DataOK]= FitData(mdev);
%FITDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.4.4 $  $Date: 2004/02/09 08:05:26 $




p= Parent(mdev);
modes= p.mle_modes;
[Xg,Yrf,Sigma]= mledata(p.info,0,modes(2));


TS= p.BestModel;
if length(modes)<=2 | modes(3)<3
   [Xgc,Yrfc,Sigmac,DataOK]= checkdata(TS,Xg,Yrf,Sigma);
else
   [Xl,Yl]= getdata(p.info,'FIT');
   [Xl,yl,DataOK]= lincheckdata(TS,Xl,Yl);
   Xgc= Xl{end};
end
ind= rfindex(mdev);
[X,Y]= getdata(mdev);
m= model(mdev);
if isSameTgt(TS)
    % all coding done at two-stage level so need to uncode
    X(DataOK,:)= invcode(m,Xgc);
end

Y(:,1)= Yrf(:,ind);


