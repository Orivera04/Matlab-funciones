function [pInputs, data, istablelink] = getSavedInputData(obj)
%GETSAVEDINPUTS Get the saved input data
%
%  [PINPUTS, DATA, ISTABLELINK] = GETSAVEDINPUTS(OBJ) returns the list of
%  the current inputs, the saved data for the current inputs and a logical
%  vector indicating whether each point is linked to a table cell.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:36:27 $ 

pInputs = [pGetTableInputs(obj), pGetOtherInputs(obj)];

setInputsAt(obj, 'all');
data = pveceval(pInputs, @getvalue);
data = [data{:}];

istablelink = hasTableLink(obj.DataKeyTable);
