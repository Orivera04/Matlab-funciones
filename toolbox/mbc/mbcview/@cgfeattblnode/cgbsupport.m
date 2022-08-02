function supp=cgbsupport(nd, pSub, supp)
%CGBSUPPORT Get cgbrowser supported options
%
%  SUPP=CGBSUPPORT(OBJ, pSUB, SUPP) where SUPP is a structure of options
%  and pSUB is a pointer to teh subitem to be shown, gets the options for
%  this particular node/subitem combination.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:23:55 $

supp.calmanager = true;
supp.allowduplication = false;
supp.helptopics = {'&Table Help','CGTABLEVIEW'};
