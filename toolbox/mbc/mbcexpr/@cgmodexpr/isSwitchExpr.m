function ret = isSwitchExpr(m)
%ISSWITCHEXPR Return true if expression is a switching expression
%
%  RET = ISSWITCHEXPR(OBJ) returns true for switching expression.  These
%  expression types have valid evaluations only at certain input points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:13:15 $ 

ret = isSwitchModel(m.model) || isSwitchExpr(m.cgexpr);