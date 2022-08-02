function setactive(modelName)
%SETACTIVE Set a global model.
%
%  SETACTIVE(MODELNAME) 
%        It is used to set a model being global.
%
%  INPUT:  
%        modelName: name of model
%
%  OUTPUT:
%        none

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.8.4.1 $  
%  $Date: 2004/04/15 00:28:52 $

global activeModel;
activeModel = modelName;

