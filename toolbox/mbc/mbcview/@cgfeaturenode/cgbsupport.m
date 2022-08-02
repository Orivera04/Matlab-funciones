function supp=cgbsupport(nd, pSub, supp)
%CGBSUPPORT Get cgbrowser supported options
%
%  SUPP=CGBSUPPORT(OBJ, pSUB, SUPP) where SUPP is a structure of options
%  and pSUB is a pointer to teh subitem to be shown, gets the options for
%  this particular node/subitem combination.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/02/09 08:22:39 $

supp.calmanager=1;
if ~issubfeature( nd )
    supp.allowremoval=1;
else
    % this must be a subfeature, hence can not be deleted
    supp.allowremoval=0;
end

supp.renderer='painters';
supp.surfaceviewer=1;
supp.helptopics={'&Feature Help','CGFEATUREVIEW'};
