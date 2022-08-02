function setsolutionvalues(optim, Nsol, Nop)
%SETSOLUTIONVALUES Set variables to given solution values
%
%  SETSOLUTIONVALUES(OPTIM, NSOL, NOPPOINT) sets all of the variables in
%  the output matrix of data to ahve the values referenced by solution NSOL
%  and operating point NOPPOINT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:58 $ 

[data, strings, pItems] = getsolution(optim, Nsol, Nop);
if ~isempty(pItems)
    bInports = pveceval(pItems, 'isinport');
    bInports = [bInports{:}];
    passign(pItems(bInports), pvecinputeval(pItems(bInports), 'setvalue', num2cell(data(bInports))));
end