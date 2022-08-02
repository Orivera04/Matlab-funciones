function supp=MBsupport(tp,supp)
% MBsupport set MBrowser supported options
%
%  supp=MBsupport(supp)
%
%    supp is a structure of options
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:03:12 $

% allow new testplans
supp.newmodel=1;
supp.export=0;
supp.helptopics={'&Project Help','xreg_projectView'};