function firecb(obj)
% FIRECB   Fire callback string of a splitlayout
%
%   FIRECB(OBJ) parses and executes the callback string
%   defined for a rb_group object.  The parser picks out the
%   string %OBJECT% and replaces it with a copy of the object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:06 $

ud=obj.datastore.info;
cbstr=ud.callbackstr;
if ~isempty(cbstr)
   % parse for %OBJECT%
   
   pcs=findstr(cbstr,'%');
   
   go=1;
   needobj=0;
   needval=0;
   while (go<=(length(pcs)-1))
      cmp=cbstr(pcs(go)+1:pcs(go+1)-1);
      if strcmp(cmp,'OBJECT')
         needobj=1;
         cbstr=[cbstr(1:pcs(go)-1) 'XX_SPLITLAYOUTOBJECT_XX' cbstr(pcs(go+1)+1:end)];
         go=go+2;
      else
         go=go+1;
      end
   end
   
   if needobj
      assignin('base','XX_SPLITLAYOUTOBJECT_XX',obj);
   end
   evalin('base',cbstr);
   
   % clear up base workspace
   evalin('base','clear(''XX_SPLITLAYOUTOBJECT_XX'');');   
end
return
