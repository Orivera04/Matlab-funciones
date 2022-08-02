function str=texview(m)
% MODEL/TEXVIEW TeX string for displaying model 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:20 $

% --------------------------------------------
% Call methods that supply all the information
Expr =    str_code(m,1);
fX =      str_func(m,1);
ytrans =  str_yinv(m,1);
chModel = char(m,1);
str = {'\bf{Coding}',Expr,...
      '\bf{Equation}',fX,chModel,...
      '\bf{Y Transformation}',ytrans};



