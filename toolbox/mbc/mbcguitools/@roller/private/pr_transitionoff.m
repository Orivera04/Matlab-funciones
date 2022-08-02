function pr_transitionoff(rl)
%ROLLER/PRIVATE/PR_TRANSITIONOFF   Private function
%   Private rolling function for roller object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:23 $


% Rolling on needs to pull the on text and frame up to show off status
ROLLCOUNT=pr_getrolls;

% only do if object is visible
if get(rl.frame1,'userdata')
   endpos=get(rl.frame1,'position');
   % set frame2 start pos
   onpos=[endpos(1) endpos(2)+1 endpos(3) endpos(4)-1];
   offpos=[endpos(1) endpos(2) endpos(3) 1];
   set(rl.frame2,'position',onpos);
   set(rl.frame1,'visible','on','position',offpos);
   ontxt=1;
   offtxt=0;
   amp=endpos(4)-2;
   drawnow;
   for t=pi:-pi/ROLLCOUNT:0
      onpos(2)=1+endpos(2)+amp*(cos(t)+1)/2;
      onpos(4)=endpos(2)+endpos(4)-onpos(2);
      offpos(4)=1+amp*(cos(t)+1)/2;
      
      set([rl.frame1;rl.frame2],{'position'},{offpos;onpos});
      if ontxt & onpos(4)<3;
         set(rl.text2,'visible','off');
         ontxt=0;
      end
      if ~offtxt & offpos(4)>3
         set(rl.text1,'visible','on');
         offtxt=1;
      end
      if offtxt
         set(rl.text1,'position',[offpos(1)+1 offpos(2)+1 offpos(3)-2 offpos(4)-2]);
      end
      if ontxt
         set(rl.text2,'position',[onpos(1)+1 onpos(2)+1 onpos(3)-2 onpos(4)-2]);
      end
      drawnow;
   end
   % finish off neatly
   set(rl.frame2,'visible','off','position',endpos); 
   set([rl.text2;rl.text1],'position',[endpos(1)+1 endpos(2)+1 endpos(3)-2 endpos(4)-2]);
   set(rl.frame1,'position',endpos);
end
