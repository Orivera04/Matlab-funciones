function pr_transitionon(rl)
%ROLLER/PRIVATE/PR_TRANSITIONON   Private function
%   Private rolling function for roller object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:24 $

% Rolling on needs to pull the on text and frame down from above
ROLLCOUNT=pr_getrolls;

% only do if object is visible
if get(rl.frame1,'userdata')
   endpos=get(rl.frame1,'position');
   % set frame2 start pos
   onpos=[endpos(1) endpos(2)+endpos(4)-1 endpos(3) 1];
   offpos=[endpos(1) endpos(2) endpos(3) endpos(4)-1];
   set(rl.frame2,'position',onpos,'visible','on');
   ontxt=0;
   offtxt=1;
   amp=endpos(4)-2;
   drawnow;
   for t=0:pi/ROLLCOUNT:pi
      onpos(2)=1+endpos(2)+amp*(cos(t)+1)/2;
      onpos(4)=endpos(2)+endpos(4)-onpos(2);
      % do frames
      offpos(4)=1+amp*(cos(t)+1)/2;
      set([rl.frame1;rl.frame2],{'position'},{offpos;onpos});
      % check for turning on ontxt and off offtxt
      if ~ontxt & onpos(4)>=3;
         set(rl.text2,'visible','on');
         ontxt=1;
      end
      if offpos(4)<3
         set(rl.text1,'visible','off');
         offtxt=0;
      end
      if ontxt
         set(rl.text2,'position',[onpos(1)+1 onpos(2)+1 onpos(3)-2 onpos(4)-2]);
      end
      if offtxt
         set(rl.text1,'position',[offpos(1)+1 offpos(2)+1 offpos(3)-2 offpos(4)-2]);
      end
      drawnow;
   end
   % finish off neatly
   set(rl.frame1,'visible','off','position',endpos);
   set([rl.text1;rl.text2],'position',[endpos(1)+1 endpos(2)+1 endpos(3)-2 endpos(4)-2]);
   set(rl.frame2,'position',endpos);
end


