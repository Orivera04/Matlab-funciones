function str=plainview(m,VarName)
% MODEL/PLAINVIEW string for viewing without TeX formatingf

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:52 $

% --------------------------------------------
% Call methods that supply all the information
Expr =    str_code(m,0);
fX =      str_func(m,0);
ytrans =  str_yinv(m,0);
chModel = char(m);
str = {Expr,fX,chModel,ytrans};




