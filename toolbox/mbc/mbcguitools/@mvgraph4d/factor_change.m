function factor_change(gr,obj)
%FACTOR_CHANGE   Callback function
%   Callback function for the graph4d object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:19:43 $

% check exclusive setting
ud = gr.DataPointer.info;
if ud.factorselection
   % need to make sure the other selections aren't the same
   dir=str2num(get(obj,'tag'));
   if dir~=4
      vals=get([gr.xfactor;gr.yfactor;gr.zfactor],{'value'});
      vals=cat(1,vals{:});
      val=vals(dir);
      reps=find(vals==val);
      if length(reps)>1
         flds={'xfactor','yfactor','zfactor'};
         chng=setxor(reps,dir);
         hndl=gr.(flds{chng});
         % find a new value to set it to
         used=vals;
         avail=1:4;
         new=setxor(used,avail);
         new=new(1);
         str=get(gr.xfactor,'string');
         if new<=length(str)
            set(hndl,'value',new)
         end
      end
   end
end

pr_graphlim(gr);
pr_plot(gr);
return