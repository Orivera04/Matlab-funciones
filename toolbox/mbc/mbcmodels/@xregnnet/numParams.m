function nPar= numParams(m)
% NNMODEL/NUMPARAMS Returns number of parameters
% in the neural network model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:28 $

% initialise nPar
nPar= 0;

% calculate number of inputs
inpNum= m.param.inputs{1}.size;

% first set of parameters = number of inputs
layerParam(1)= inpNum;

% calculate number of parameters in
% hidden and output layers
for i=2:(m.param.numLayers+1)
   % layerParam is equal to number of hidden neurons and
   % it also equal to number of bias in the current
   % network layer
   layerParam(i)= m.param.layers{i-1}.size;
   nPar= nPar + layerParam(i)*layerParam(i-1) + ...
      layerParam(i);
end
