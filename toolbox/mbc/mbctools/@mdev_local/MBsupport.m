function supp=MBsupport(mdev,supp)
% MBsupport set MBrowser supported options
%
%  supp=MBsupport(supp)
%
%    supp is a structure of options
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:04:04 $


% Check for new model allowed
supp.newmodel=1;
supp.print=1;
TS= BestModel(mdev);
if isempty(TS) | ~ismle(TS);
	supp.validate= numSubModels(mdev)>=1;
else
	supp.validate=0;
end

supp.evaluate= true;
supp.validate= true;

supp.helptopics = {'&Local Model Help','xreg_localModelView'};