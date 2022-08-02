function out = JuppFilter(Znx,Idx)
%JUPPFILTER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:50:11 $

if isempty(Idx) | length(Idx) == 1 % In either case no problem with repeated locked BP's
   out = Znx;
else
   Xlocked = Znx(Idx);
   if min(diff(Xlocked))~= 0
      out = Znx; % now repeated locked BP's
   else % Problem case
      if Idx(1) == 1
         store = Znx(1);
      else
         store = Znx(1:Idx(1)-1);
      end
      count = 2;
      while count <= length(Idx)
         if Znx(Idx(count-1)) ~= Znx(Idx(count))
            store = [store;Znx(Idx(count-1)+1:Idx(count))];
         end
         count = count+1;
      end
      store = [store; Znx(Idx(end)+1:length(Znx))];
      out = store;
   end
end  

return