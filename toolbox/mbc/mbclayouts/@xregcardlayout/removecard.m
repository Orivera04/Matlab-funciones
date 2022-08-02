function crd=removecard(crd,cardno,del)
% REMOVECARD  Remove a card from a xregcardlayout
%
%  C=REMOVECARD(C,CARDNO) removes the card CARDNO from the
%  cardlayout C.  All objects attached to the card are
%  deleted.
%  C=REMOVECARD(C,CARDNO,'nodelete') removes references to
%  the attached objects but does not delete them.
%  C=REMOVECARD(C) removes the current card.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:58 $

if nargin<3
   del=1;
else
   if strcmp(del,'nodelete')
      del=0;
   else
      del=1;
   end
end

ud=crd.g.info;
if nargin<2
   cardno=ud.currentcard;
end

if ud.currentcard==cardno
   % switch cards to next one or previous if it doesn't exist
   if ud.numcards>cardno
      newcardno=cardno+1;
   else
      newcardno=cardno-1;
   end
   set(crd,'currentcard',newcardno);
   ud=crd.g.info;
end

ud.numcards=ud.numcards-1;
h=get(crd.xregcontainer,'elements');

if ~isempty(h)
   keepind=(ud.cards~=cardno);
   set(crd.xregcontainer,'elements',h(keepind));
   cards=ud.cards(keepind);
   cards(cards>cardno)=cards(cards>cardno)-1;
   ud.cards=cards;
   ud.id=ud.id(keepind);
   
   if del
      hdel=h(~keepind);
      for i=1:length(hdel)
         delete(hdel{i});
      end
   end
end

if ud.currentcard>cardno
   ud.currentcard=ud.currentcard-1;
end

if ud.numcards==0
   % re-initialise with a blank card
   ud.numcards=1;
   ud.currentcard=1;
end
crd.g.info=ud;
return

