function id=attach(obj,h,card)
% ATTACH   Attach object to xregcardlayout
%
%   ID=ATTACH(OBJ,H) attaches the object H to the xregcardlayout
%   OBJ.  The returned ID may be used to reference H for future
%   xregcardlayout operations.
%
%   ID=ATTACH(OBJ,H,CARD) attaches H to the specified card index.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:34:50 $


ud=obj.g.info;

if nargin<3
   card=ud.currentcard;
elseif card<1 | card>ud.numcards
   error('Index greater than number of cards!');
   return
end

crds=ud.cards;
crds(end+1)=card;
ud.cards=crds;

if card==ud.currentcard & ud.visible
   set(h,'visible','on');
else
   set(h,'visible','off');
end

% add object to xregcontainer without repacking
el=get(obj.xregcontainer,'elements');
el(end+1)={h};
set(obj.xregcontainer,'elements',el);

ps=get(obj,'boolpackstatus');
if ~ps
    % Mark card as needing future redraw
    cdraw=ud.carddraw;
    cdraw(card)=1;
    ud.carddraw=cdraw;
else
    % Redraw additional handle
    pos=get(obj,'innerposition');
    pos(3:4)=max(pos(3:4),[1 1]);
    set(h,'position',pos);
end

% get id and save it
id=ud.nextid;
ids=ud.id;
ids(end+1)=id;
ud.id=ids;
ud.nextid=id+1;

obj.g.info=ud;
return
