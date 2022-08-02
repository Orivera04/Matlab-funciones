function supp=cgbsupport(nd, pSub, supp)
%CGBSUPPORT Get cgbrowser supported options
%
%  SUPP=CGBSUPPORT(OBJ, pSUB, SUPP) where SUPP is a structure of options
%  and pSUB is a pointer to teh subitem to be shown, gets the options for
%  this particular node/subitem combination.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.4 $  $Date: 2004/02/09 08:25:25 $

supp.calmanager = true;

if Parent(nd)==address(project(nd))
    supp.allowremoval = true;
    if issimpletable(info(getdata(nd)))
        supp.allowduplication = true;
    else
        supp.allowduplication = false;
    end
else
    supp.allowduplication = false;
    supp.allowremoval = false;
end
supp.helptopics={'&Normalizer Help','CGNORMVIEW'};
