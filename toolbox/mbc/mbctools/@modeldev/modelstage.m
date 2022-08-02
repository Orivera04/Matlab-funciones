function ms=modelstage(MD,ms)
% MODELSTAGE   get/set modelstage of modeldev
%
%   S=MODELSTAGE(MD) returns the modelstage of the modeldev MD
%   MD=MODELSTAGE(MD,S) sets the modelstage to S
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:10:41 $



% Created 23/8/2000


if nargin==1
   ms=MD.ModelStage;
   if ms==-1
      % No stage set: try to work it out
      mylvl=getlevel(MD);
      if mylvl==0 | mylvl==1
         ms=0;
      elseif mylvl==2
         if isa(model(MD),'xregtwostage')
            ms=0;
         else
            ms=1;
         end
      else
         % get modelstage of first granddaddy after root level
         pnode=MD;
         for n=1:(mylvl-2)
            pnode=Parent(pnode);
            pnode=pnode.info;
         end
         parent_ms=modelstage(pnode);
         if parent_ms==0
            % we are below a twostage model
            if mylvl==2
               ms=1;
            else
               ms=2;
            end
         else
            % we are part of a onestage model
            ms=1;
         end
      end
      
      % update pointer copy
      MDp=address(MD);
      storedMD=MDp.info;
      storedMD.ModelStage=ms;
      pointer(storedMD);
      
      % update the input copy and attempt to place update in caller workspace
      MD.ModelStage=ms;
      nm=inputname(1);
      if ~isempty(nm)
         assignin('caller',nm,MD);
      end
   end
else
   MD.ModelStage=ms;
   pointer(MD);
   ms=MD;
end
return
