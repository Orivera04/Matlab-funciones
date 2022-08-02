function delete(sl)
% DELETE   Delete listitemselector object
%
%   DELETE(L) deletes all the graphical resources associated with L
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:01 $

% Created 3/2/2000

if isempty(sl.baselist) | ~ishandle(sl.baselist)
   return
end

delete([sl.baselist;sl.sellist;sl.addone;sl.remone;sl.addall;sl.remall;sl.unselttl;sl.selttl]);

sl.baselist=[];
sl.sellist=[];
sl.addone=[];
sl.remone=[];
sl.remall=[];
sl.addall=[];
sl.unselttl=[];
sl.selttl=[];
return
