function nm=slblock(obj,sys)
%SLBLOCK  Create a simulink block for constraint
%
%  BLK=SLBLOCK(OBJ,PARENTSYS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:59:27 $

load_system('constraints');

% create name for block
basenm='2DTable%d';
search=1;
while search
   nm=sprintf(basenm,search);
   if isempty(find_system(sys,'SearchDepth',1,'Name',nm))
      search=0;
   else
      search=search+1;
   end
end
blk=[sys '/' nm];

P=getparams(obj);

add_block('constraints/3D Table constraint',blk,...
   'linkstatus','none');
% Set up parameters
ineqs={'>=','<='};
ineq=ineqs{P.le+1};
Matspr=[repmat(' %g',1,length(P.breakx)) ';'];
Matstr=['[' sprintf(Matspr, P.table')];
Matstr(end)=']';    % remove trailing ;

set_param(blk,'Nvar',sprintf('%d',getsize(obj)),...
   'Ineq',ineq,...
   'TabBrkY',['[' sprintf('%g ',P.breaky) ']'],...
   'TabBrkX',['[' sprintf('%g ',P.breakx) ']'],...
   'TabVal',Matstr,...
   'InVarY',sprintf('%d',P.factors(1)),...
   'InVarX',sprintf('%d',P.factors(2)),...
   'OutVar',sprintf('%d',P.factors(3)));
