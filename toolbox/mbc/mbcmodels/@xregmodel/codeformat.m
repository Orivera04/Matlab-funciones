function Expression=codeformat(Model,TeX)
% MODEL/CODEFORMAT string for display of coding information
%
% Expression=codeformat(Model,TeX)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:32 $

% 
% Coding Information
if isempty(TeX)
   TeX=0;
end
codes= get(Model,'code');
s=get(Model,'symbol');
syms(s{:},'x');
for i=length(codes):-1:1;
   % Uses Symbolic Toolbox
   g = codes(i).g;
   if ~isempty(g)
      gch=strrep(char(g),'.^','^');
      g=sym(gch);
      range= subs(g,x,codes(i).max)-subs(g,x,codes(i).min);
      Expr = ['subs(g,x,',s{i},')'];
   else
      range= codes(i).max-codes(i).min;
      Expr= s{i};
   end
   Expr=vpa(eval(Expr),4);
   Expr=['(',char(Expr),strrep(sprintf('-%10.4g)/(%10.4g)',codes(i).mid,range/codes(i).range),' ','')];
   if codes(i).mid<0
      Expr= strrep(Expr,'--','+');
   end
   if TeX
      Expr=texlabel(Expr);
   end
   Expr = [s{i},' = ',Expr];
   Expression{i}=Expr;
end
