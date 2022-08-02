function des=subsasgn(des,s,val)
% DESIGN/SUBSASGN
%   Provides dot indexing for design object methods

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:51 $


if length(s)==1
   tp=s.type;
   fn=s.subs;
else
   tp=s(1).type;
   fn=s(1).subs;
end

if length(s)==1
   if strcmp(tp,'.')
      des=feval(fn,des,val);
   elseif strcmp(tp,'()')
      if ~isempty(val)
         rchng=[];
         if length(fn)==2
            if ischar(fn{1}) & strcmp(fn{1},':')
               rchng=1:size(des.design,1);
            else
               rchng=fn{1};
            end
         else
            % linear/logical
            if islogical(fn{1})
               rchng=find(sum(fn{1},2));
            elseif ischar(fn{1}) & strcmp(fn{1},':')
               rchng=1:size(des.design,1);
            else
               [rchng,col]=ind2sub(size(des.design),fn{1});
            end
         end
         des.design=subsasgn(des.design,s(1),val);
         des.designindex(rchng)=0;
         des.designstate=des.designstate+1;
         des=DesignType(des,0,[]);
      end
   end
else
   if strcmp(tp,'.');
      out=feval(fn,des);
      out=subsasgn(out,s(2:end),val);
      des=feval(fn,des,out);
   end
end
return