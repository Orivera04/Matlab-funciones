function Ynv= YinvBuild(m,parent)
% MODEL/YINVBUILD builds SIMULINK blocks to perform yinv transformation

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:18 $

% Get the coding inline function
codestr=sym(m.yinv);
yvar= findsym(codestr);

% replace x with u
codestr= subs(codestr,yvar,'u');
codestr= char(codestr); 
if isempty(codestr)
   codestr='u';
end

% Add a Fcn block to the parent model
Ynv= add_block('built-in/Fcn',[parent,'/Yinv']);
set_param(Ynv,'Expr',codestr);
