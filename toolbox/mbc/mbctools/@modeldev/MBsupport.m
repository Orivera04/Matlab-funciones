function supp=MBsupport(mdev,supp)
% MBsupport set MBrowser supported options
%
%  supp=MBsupport(supp)
%
%    supp is a structure of options
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:09:38 $

switch mdev.ViewIndex,
case 'global'
   supp.newmodel=1;
   s= status(mdev);
   supp.export= s;
   supp.print=  s;
   % validation button
   supp.validate=  numChildren(mdev)>0;
   if modelstage(mdev)==1
      supp.helptopics={'&One-Stage Model Help','xreg_onestageModelView'};
   else
      supp.helptopics={'&Global Model Help','xreg_globalModelView'};
   end
case 'twostage'
   oldm= model(mdev);
   supp.newmodel= 1;
   s= hasBest(mdev) & numChildren(mdev);
   supp.export= s;
   supp.print=  s;
   bmi= children(mdev,'BMIndex');
   mleup= children(mdev,'mle_NeedsUpdate');
   supp.validate= numChildren(mdev)>0 ; %  & all([bmi{:}]) & ~any([mleup{:}]);
   supp.helptopics={'&Two-Stage Model Help','xreg_twostageModelView'};
end
supp.evaluate=hasBest(mdev);
   

