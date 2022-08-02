function setsumsolutionvalues(optim, Nsol)
%SETSUMSOLUTIONVALUES Set variables to given solution values for a sum
%
%  SETSUMSOLUTIONVALUES(OPTIM, NSOL) sets all of the variables in the
%  output matrix of data to ahve the values referenced by solution NSOL.
%  Each input will thus be set to a vector.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:59 $ 

[data, strings, pItems] = getsolution(optim, Nsol);
if ~isempty(pItems)
    bInports = pveceval(pItems, 'isinport');
    bInports = [bInports{:}];
    passign(pItems(bInports), pvecinputeval(pItems(bInports), 'setvalue', num2cell(data(:, bInports), 1)));
end