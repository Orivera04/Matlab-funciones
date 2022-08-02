function [node, OK] = editinputs(node, modelptr)
%EDITINPUTS  Show input connections  GUI
%
% ND = EDITINPUTS(ND, [MDLPTR]) 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.4.2 $  $Date: 2004/02/09 08:24:21 $

if nargin<2
    modelptr = getdata(node);
end

localdata.modptr = modelptr;
model = modelptr.get('model');
localdata.models = {model};

% just allow the connections to be edited
name = name(node);
title = sprintf('Edit Model Inputs: %s',name);
[OK, out] = xregwizard(cgf, title, {@cg_model_wizard 'cardthree'}, localdata);
