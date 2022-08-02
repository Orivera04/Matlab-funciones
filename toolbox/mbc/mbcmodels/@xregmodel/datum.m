function value=datum(m,value);
% MODEL/DATUM shift transformation for models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:40 $

if nargin ==1
   if isempty(m.code)
      value = zeros(1,nfactors(m));
   else
      value = [m.code.mid];
      ws= warning;
      warning off
      for i=1:length(value)
         g= m.code(i).g;
         if ~isempty(g)
            ginv= inline( finverse(sym(g)) );
            value(i)= ginv(value(i));
         end
      end
      warning(ws)
   end
else
   value= i_setdatum(m,value);
end

function m= i_setdatum(m,value)

c= m.code;
if ~isempty(c) 
   for i=1:length(value)
      if ~isempty(c(i).g)
         value(i)= c(i).g(value(i));
      end      
      c(i).mid= value(i);
   end
   m.code= c;
else
   if length(value)==1
      m.code= struct('min',0,'max',1,'g','','mid',value,'range',Inf);
   else
      v= num2cell(valve);
      m.code= struct('min',0,'max',1,'g','','mid',v,'range',Inf);
   end
end
   