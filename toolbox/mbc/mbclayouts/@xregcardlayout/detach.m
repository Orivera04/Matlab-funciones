function detach(obj,id)
% DETACH   Detach handle from cardlayout
%
%   DETACH(OBJ,ID) detaches the object internally identified
%   by ID from the xregcardlayout OBJ.  ID is returned by the
%   xregcardlayout ATTACH function.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:52 $

ud=obj.g.info;
% find object index
ind=find(ud.id==id);

ud.cards(ind)=[];
ud.id(ind)=[];

remove(obj.xregcontainer,ind);

obj.g.info=ud;

return