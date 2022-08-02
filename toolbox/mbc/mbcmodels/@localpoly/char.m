function s=char(p,TeX,var);
% POLYNOM/CHAR convert polynom object to character array for display

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:40:17 $



if nargin==1
   TeX=1;
end

if nargin<3
   s= get(p,'symbol');
   var=s{1};
end
if TeX 
   var= detex(var);
end

c=double(p);
c(abs(c) < max(abs(c))*eps)=0;

if all(c==0)
   s='0';
else
   d= length(c)-1;
   s=[];
   for a=c';
      if a~=0
         if ~isempty(s)
            if a > 0
               s = [s ' + '];
            else
               s = [s ' - '];
               a = -a;
            end
         end
         if a~=1 | d==0
            s = [s sprintf('%.3g',a)];
            if d > 0
               s = [s '*'];
            end
         end
         if d >= 2
            s= [s var '^' int2str(d)];
         elseif d == 1
            s= [s var];
         end
      end
      d = d-1;
   end
end

            

