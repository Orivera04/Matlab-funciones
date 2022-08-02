function nm=slblock(obj,sys)
%SLBLOCK  Create a simulink block for constraint
%
%  BLK=SLBLOCK(OBJ,PARENTSYS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:59:19 $

load_system('constraints');

% create name for block
basenm='1DTable%d';
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

add_block('constraints/2D Table constraint',blk,...
   'linkstatus','none');
% Set up parameters
ineqs={'>=','<='};
ineq=ineqs{P.le+1};
set_param(blk,'Nvar',sprintf('%d',getsize(obj)),...
   'Ineq',ineq,...
   'TabBrk',['[' sprintf('%g ',P.breakx) ']'],...
   'TabVal',['[' sprintf('%g ',P.table) ']'],...
   'InVar',sprintf('%d',P.factors(1)),...
   'OutVar',sprintf('%d',P.factors(2)));