function cbactivate(rl)
% ROLLER/CBACTIVATE   Trigger a roller callback
%
%  CBACTIVATE(R) triggers the callback routine that is currently
%  defined in the object R.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:03 $

% Created 26/11/99


ud=get(rl.text2,'userdata');

% trigger callback routine
if ud.cbactive
   % parse for %VALUE% and %OBJECT%
   
   pcs=findstr(ud.callback,'%');
   
   go=1;
   needobj=0;
   needval=0;
   while (go<=(length(pcs)-1))
      cmp=ud.callback(pcs(go)+1:pcs(go+1)-1);
      if strcmp(cmp,'VALUE')
         needval=1;
         ud.callback=[ud.callback(1:pcs(go)-1) 'XX_CBVALUE_XX' ud.callback(pcs(go+1)+1:end)];
         go=go+2;
      elseif strcmp(cmp,'OBJECT')
         needobj=1;
         ud.callback=[ud.callback(1:pcs(go)-1) 'XX_CBOBJECT_XX' ud.callback(pcs(go+1)+1:end)];
         go=go+2;
      else
         go=go+1;
      end
   end
   
   if needobj
      assignin('base','XX_CBOBJECT_XX',rl);
   end
   if needval
      assignin('base','XX_CBVALUE_XX',get(rl.frame2,'userdata'));
   end
   evalin('base',ud.callback);
   
   % clear up base workspace
   evalin('base','clear(''XX_CBOBJECT_XX'',''XX_CBVALUE_XX'');');   
   
end
return