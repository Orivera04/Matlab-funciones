function newpos = cgsetblockpos(blk,pos,all)
% CGSETBLOCKPOS
% newpos = cgsetblockpos(BlkIdentifier,DesiredPosition,AllBlockPositions);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:17:33 $
space = 20;
if nargin ~= 3
   error('Wrong number of arguments')
else
   % Make sure blocks don't go too high
   if pos(2)<40
      delta = 40 - pos(2);
      pos = pos + [0 delta 0 delta];
   end
   right = ~(pos(1)>all(:,3));
   left = ~(pos(3)<all(:,1));
   bottom = ~(pos(2)>all(:,4));
   top = ~(pos(4)<all(:,2));
   overlap = (left&right)&(top&bottom);
   if any(overlap)      
      % Find first overlapping block
      index = find(overlap);
      index=index(1);
      if pos(2)>all(index,2) | all(index,2)<(pos(4)-pos(2))
         % move it down
         delta = all(index,4)-pos(2);
      else
         % move it up
         delta = pos(4)-all(index,2);
      end
      %shift
      newpos = pos + [0 delta+space 0 delta+space];
      overlap = ~((newpos(1)>all(:,3))|(newpos(3)<all(:,1)))&~((newpos(2)>all(:,4))|(newpos(4)<all(:,2)));
      if any(overlap)
         index = find(overlap);
         index=index(1);
         if pos(1)>all(index,1)
            % move it left
            delta = all(index,3)-pos(1);
         else
            % move it right
            delta = pos(3)-all(index,1);
         end
         %shift 
         newpos = pos + [0 delta+space 0 delta+space];
      end
   else
      newpos = pos;
   end
   set_param(blk,'position',newpos);
end



