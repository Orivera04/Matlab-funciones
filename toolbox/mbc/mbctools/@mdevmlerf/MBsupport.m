function supp=MBsupport(mdev,supp)
% MBsupport set MBrowser supported options
%
%  supp=MBsupport(supp)
%
%    supp is a structure of options
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:05:27 $

supp.newmodel=0;
supp.export= 1;
supp.print=  1;
supp.validate=0;
supp.evaluate=1;
supp.helptopics = {'MLE &Response Feature Help','xreg_mlerfModelView'};
