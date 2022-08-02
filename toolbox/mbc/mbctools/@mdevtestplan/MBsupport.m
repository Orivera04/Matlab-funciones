function supp=MBsupport(tp,supp)
% MBsupport set MBrowser supported options
%
%  supp=MBsupport(supp)
%
%    supp is a structure of options
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:07:19 $

% Check for new model allowed
supp.newmodel = 1;

if numChildren(tp)>0
	ok=  children(tp,'hasBest');
   supp.export= all([ok{:}]);
else
	supp.export= 0;
end

supp.helptopics = {'&Testplan Help','xreg_testplanView'};