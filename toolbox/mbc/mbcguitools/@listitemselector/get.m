function out=get(sl,prop)
% GET   Get interface for the listitemselector object
%
%   VAL=GET(SL,'Property') returns the current value of the
%   property from SL.
%   Valid properties are:
%    'Visible'
%    'Position'
%    'Parent'
%    'Enable'
%    'Buttonsep'
%    'Selecteditems'
%    'Unselecteditems'
%    'Itemlist'
%    'Selectedindices'
%    'Unselectedindices'
%    'SelectedTitle'
%    'UnselectedTitle'
%    'Callback'
%    'Userdata'
%    'Selectfcn'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:03 $

% Created 2/2/2000


ud=get(sl.baselist,'userdata');


switch lower(prop)
case 'visible'
   % visible
   out=get(sl.baselist,'visible');
   
case 'position'
   % position
   out=ud.position;
   
case 'parent'
   out=get(sl.baselist,'parent');  
case 'enable'
   % enable
   out=get(sl.baselist,'enable');
case 'buttonsep'
   out=ud.buttonsepdist;
case 'itemlist'
   out=ud.reallist;
case 'selecteditems'
   out=ud.reallist(ud.sel);
case 'unselecteditems'
   out=ud.reallist(ud.unsel);
case 'selectedindices'
   out=ud.sel;
case 'unselectedindices'
   out=ud.unsel;
case 'selectedtitle'
   out=get(sl.selttl,'string');
case 'unselectedtitle'
   out=get(sl.unselttl,'string');
case 'callback'
   out=ud.callback;
case 'userdata'
   out=ud.userdata;
case 'selectfcn'
   out=ud.selectfcn;
otherwise
   out=[];
   
end
