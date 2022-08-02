function obj = setpoint(obj)
%SETPOINT Setpoint method for expressions
%
%  OBJ = SETPOINT(OBJ) resets all of the input ports of the expression to
%  their nominal values.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.2.2 $  $Date: 2004/02/09 07:09:49 $

inptrs = getinports(obj);
pveceval(inptrs, 'setpoint');