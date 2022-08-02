function el=getcard(obj,cardno)
% GETCARD  Return objects on card
%
%   OBJ=GETCARD(OBJ,CARDNO) returns a cell array of the objects
%   attached to the card CARDNO.  If CARDNO is omitted, the current
%   card is assumed.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:54 $

ud=obj.g.info;
if nargin<2
   cardno=ud.currentcard;
end

objs=(ud.cards==cardno);

el=get(obj.xregcontainer,'elements');
el=el(objs);
return
