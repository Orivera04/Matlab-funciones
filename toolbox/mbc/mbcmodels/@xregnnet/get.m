function Value = get(nn, Property, varargin);
% NNMODEL/GET
%
%   Properties:
%       HiddenLayers    -  Number of layers
%       HiddenNeurons   -  Vector of neurons for each layer
%       Algorithm       -  
%       LearningRate    -  
%       MomentumConstant-  
%       maxIter         -  
%       Mu              -  
%       Mu_inc          -  
%       Mu_dec          -  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:56:20 $
if nargin == 1
   Value = [{'hiddenlayers','algorithm','learningrate','momentumconstant',...
				'maxiter','mu','mu_inc','mu_dec'}'
		get(nn.xregmodel);fieldnames(nn.param)];
else
   switch lower(Property)
   case 'hiddenlayers'
      Value=nn.param.numlayers-1;
      
   case 'hiddenneurons'
      for n=1:nn.param.numlayers-1
         Value(n)=nn.param.layers{n}.dimensions;
      end
      Value=Value(:)';     
      
   case 'algorithm'
      Value = nn.param.trainfcn;
   case 'learningrate'
      Value = nn.param.trainparam.lr;
   case 'momentumconstant'
      Value = nn.param.trainparam.mc;
   case 'maxiter'
      Value = nn.param.trainparam.epochs; 
   case 'mu'
      Value = nn.param.trainparam.mu;
   case 'mu_inc'
      Value = nn.param.trainparam.mu_inc;
   case 'mu_dec'
      Value = nn.param.trainparam.mu_dec;
   otherwise
      try
         Value=get(nn.xregmodel,Property);
      catch
         try
            Value = nn.param.(Property);
         catch
            error('NNMODEL/GET invalid property');
         end
      end
   end   
end
