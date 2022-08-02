function N= name(T,newname)
%NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:59 $

if nargin==1
   N=T.Name;
else
   p= T.Parent;
   if p~=0
      % make sure name is not shared with other siblings
      AllNames= p.children('name');
      c=childindex(T);
      AllNames(c)=[];
      BaseName=newname;
      ind=1;
      while ismember(newname,AllNames);
         newname=[BaseName,'(',int2str(ind),')'];
         ind = ind+1;
      end
   end
   T.Name= newname;
   pointer(T);
   N=T;
end