function supp=cgbsupport(nd, pSub, supp)
%CGBSUPPORT Get cgbrowser supported options
%
%  SUPP=CGBSUPPORT(OBJ, pSUB, SUPP) where SUPP is a structure of options
%  and pSUB is a pointer to teh subitem to be shown, gets the options for
%  this particular node/subitem combination.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:23:06 $

supp.renderer='painters';
supp.relabelmanager=@i_renamemanager;
supp.removalmanager='remove';
supp.removaldecider='searchvarusage';
if length(nd.ptrlist)
   supp.allowremoval=true;
   supp.allowlabeledit=true;
   supp.allowduplication = true;
else
   supp.allowremoval=false;
   supp.allowlabeledit=false;
   supp.allowduplication = false;
end
supp.helptopics={'&Variable Dictionary Help','CGDDVIEW'};


function ok = i_renamemanager(dd, pItem, name)
[ok, syms] = renameDDitem(dd, pItem, name);
if length(syms)>0
    cgb = cgbrowser;
    cgb.doDrawList('update', address(dd), syms);
end
