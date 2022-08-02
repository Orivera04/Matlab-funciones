function Ynv= YinvDiffBuild(m,parent)
% MODEL/YINVDIFBUILD builds SIMULINK blocks to calculate derivative of yinv transformation

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:19 $

% Add a Fcn block to the parent model
Ynv= add_block('built-in/Fcn',[parent,'/Yinvdiff']);
% Default expr
expr = '1';
% Is there a transformation?
if ~isempty(m.yinv)
   [dy,expr] = yinvdiff(m,1);
% How about transform both sides
elseif m.TransBS & ~isempty(m.ytrans)
   % Warning off for finverse
   ws= warning;
   warning off
   % Calculate inverse transformation using symbolic toolbox
   m.yinv   = finverse(sym(m.ytrans));
   warning(ws)
   [dy,expr] = yinvdiff(m,1);
end

if ~isstr(expr)
   yvar = findsym(expr);
   expr= char(subs(expr,yvar,'u'));
end

set_param(Ynv,'expr',expr);
