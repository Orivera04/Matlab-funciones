function nAx = getNumAxes(obj)
%GETNUMAXES Return number of dimensions of table
%
%  N = GETNUMAXES(OBJ) retirns the number of dimensions in a table.  For
%  exmaple, cglookupones and cgnormfunctions return 1 and cglookuptwos
%  return 2.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:18 $ 

nAx = length(getinputs(obj));