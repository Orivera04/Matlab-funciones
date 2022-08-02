function Expression=str_code(Model,TeX)
% model/str_code
%   Expression=str_code(Model,TeX)
%   Outputs a cell array of formatted expressions of coding information
%   TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:12 $

if isempty(TeX)
   TeX=0;
end
[Bnds,g,Tgt]= getcode(Model);


s=get(Model,'symbol');
if TeX
	s= detex(s);
end

Expression=cell(1,nfactors(Model));
for i=size(Bnds,1):-1:1
   % Uses Symbolic Toolbox
   Expr = sprintf('%s: [%.4g,%.4g] \\rightarrow ',s{i},Bnds(i,:));
   if ~isempty(g{i})
      gs=sym(g{i});
      Expr = [Expr char( texlabel(subs(gs,'x',s{i}) ) ) ':'];
   else
      Expr= [Expr s{i},': '];
   end
   
   if ~all(isfinite(Tgt(i,:)))
      if ~isempty(g{i})
         Tgt(i,:)= g{i}(Bnds(i,:));
      else
         Tgt(i,:)= Bnds(i,:);
      end
   end
   Expr= [Expr, sprintf('[%.4g,%.4g]',Tgt(i,:))];
   Expression{i}=Expr;
end
return