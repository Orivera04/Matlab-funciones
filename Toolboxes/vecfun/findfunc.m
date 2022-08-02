function [i1,i2]=findfunc(x,func)
%FINDFUNC  Find functions in string.
%   [I1,I2] = FINDFUNC(S,FUNC) returns the indexes where the functions
%   with name FUNC are located within string or token list S.
%
%   Examples:
%       [I1,I2] = FINDFUNC('4+5*sin(x+y)-z','sin')
%       I1 = 5, I2 = 12
%
%       [I1,I2] = FINDFUNC('3+abs(4)+sin(x+y)-5+abs(x+y)','abs')
%       I1 = [3 21], I2 = [8 28]
%
%   See also FINDSTR.

% Copyright (c) 2001-04-18, B. Rasmus Anthin.

if size(x,1)>1
   i1=[];
   for i=1:size(x,1)
      if strncmp(x(i,:),func,length(func)) & x(i+1,1)=='('
         i1=[i1 i];
      end
   end
   i2=size(x,1);
   for i=1:length(i1)
      par=1;
      for j=i1(i)+2:size(x,1)
         switch x(j,1)
         case '(', par=par+1;
         case ')', par=par-1;
         end
         if ~par
            i2(i)=j;
            break;
         end
      end
   end
else
   i1=findstr(x,[func '(']);
   i2=length(x);
   for i=1:length(i1)
      par=1;
      for j=i1(i)+2:length(x)
         switch x(j)
         case '(', par=par+1;
         case ')', par=par-1;
         end
         if ~par
            i2(i)=j;
            break;
         end
      end
   end
end
if isempty(i1), i2=[];end
if isempty(func)
   i1=[];
   i2=[];
end