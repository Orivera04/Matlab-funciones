function output = evalconmodel(obj)
%EVALCONMODEL A short description of the function
%
%  OUT = EVALCONMODEL(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:56:10 $ 

output = [];
modptr=obj.modptr; 
pOp = obj.oppoint;
weights = obj.weights;

% Get number of points in the data set
N = pOp.get('numpoints');

if length(weights) ~= N
   error('mbc:consumcgmodel:InvalidState', 'Length of weights vector not identical to number of operating points');
end

% Get all the data-dictionary inputs to the model
ddptrs =modptr.getinports;
saveval= pveceval(ddptrs,'getvalue');

% New Data matrix for inputs
NewData = cell(1, length(ddptrs));

% Filter inputs
ptrsin = [];
ptrsNOTin = [];
dsptrs = get(pOp.info, 'ptrlist');
if isempty(dsptrs)
    error('mbc:consumcgmodel:InvalidState', 'Operating point set is empty');
end
inind = find(ismember(ddptrs, dsptrs));
notinind =setdiff(1:length(ddptrs), inind);
ptrsin = ddptrs(inind);
ptrsnotin = ddptrs(notinind);

% Set values of inputs in data set
if ~isempty(ptrsin)
    data = pOp.get('data');
    dd_ind = getFactorIndex(info(pOp),ddptrs);
    NewData= num2cell(data(:,dd_ind(find(dd_ind))),1);
end
passign(ddptrs(inind), pvecinputeval(ddptrs(inind),'setvalue',NewData) );

% Evaluate sum model
try
    output = pveceval(modptr,@i_eval);
    output = (output{1})'*weights;
catch
    passign(ddptrs, pvecinputeval(ddptrs,'setvalue',saveval) );
    error('mbc:consumcgmodel:UnknownError', 'Problem evaluating an objective or constraint');
end

% Restore old values
passign(ddptrs(inind), pvecinputeval(ddptrs(inind),'setvalue',saveval(inind)) );