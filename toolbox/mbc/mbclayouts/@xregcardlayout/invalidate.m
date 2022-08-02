function invalidate(obj,crd)
%INVALIDATE  Mark Cardlayout draw status as invalid
%
%  Normally the xregcardlayout watches for changes to it's cards only repacks
% them as necessary.  Sometimes this may cause underpacking when sub-layouts
% are tweaked without it knowing.
%
%  INVALIDATE(CARDLYT) marks the xregcardlayout as no longer being validly drawn
%  INVALIDATE(CARDLYT,CARDNUM) marks the specified card(s) as invalid
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:55 $

ud=obj.g.info;

if nargin
   ud.carddraw(crd)=1;
else
   ud.carddraw(:)=1;
end
obj.g.info=ud;

return