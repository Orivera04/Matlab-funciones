function varargout = set(nn, Property, Value);
% NNMODEL/SET
%
%   Properties:
%       HiddenLayers    -  Number of layers
%       HiddenNeurons   -  Vector of neurons for each layer
%       Algorithm       -  traingdm, trainbr or trainlm
%       LearningRate    -  
%       MomentumConstant-  
%       maxIter         -  
%       Mu              -  
%       Mu_inc          -  
%       Mu_dec          -  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:56:31 $


switch lower(Property)
case 'hiddenlayers'
   if Value>=1 & Value<=2 & (Value~=nn.param.numlayers-1)
      oldnn=nn.param;
      if Value==1
         nns=[nn.param.layers{1}.dimensions 1];
         opts={'tansig','purelin'};
      else
         nns=[nn.param.layers{1}.dimensions 5 1];
         opts={'tansig' 'tansig' 'purelin'};
      end
      newnn=newff(repmat([-1 1],nfactors(nn),1),nns,opts,'trainbr');
      % copy in old parameters
      newnn.trainparam.lr=oldnn.trainparam.lr;
      newnn.trainparam.mc=oldnn.trainparam.mc;
      newnn.trainparam.mu=oldnn.trainparam.mu;
      newnn.trainparam.mu_dec=oldnn.trainparam.mu_dec;
      newnn.trainparam.mu_inc=oldnn.trainparam.mu_inc;
      newnn.trainparam.epochs=oldnn.trainparam.epochs;
      newnn.trainParam.goal = oldnn.trainparam.goal;			
      newnn.trainParam.min_grad = oldnn.trainparam.min_grad;
      newnn.trainParam.show = oldnn.trainparam.show;	
      nn.param=newnn;
   end
   
case 'hiddenneurons'
   if length(Value)==nn.param.numlayers-1
      for n=1:length(Value)
         nn.param.layers{n}.dimensions=Value(n);
      end    
   end
   
case 'algorithm'
   switch lower(Value)
   case {'traingdm','trainlm','trainbr'}
      % retain current values for other settings
      sets = nn.param.trainParam;      
      nn.param.trainFcn = Value;
      nn.param.trainParam = sets; 
   end
   
case 'learningrate'
   if Value>=0.005 & Value<=0.05
      nn.param.trainparam.lr = Value;
   end
   
case 'momentumconstant'
   if Value>=0.1 & Value<=0.9
      nn.param.trainparam.mc = Value;
   end
 
case 'maxiter'
   nn.param.trainparam.epochs = Value;
   nn.param.trainparam.show = max(10,ceil(Value/10));
   
case 'mu'
   if Value>=0.001 & Value<=0.01
      nn.param.trainparam.mu = Value;
   end
case 'mu_inc'
   if Value>=1 & Value<=10
      nn.param.trainparam.mu_inc = Value;
   end
   
case 'mu_dec'
   if Value>=0.05 & Value<=.5
      nn.param.trainparam.mu_dec = Value;
   end
   
otherwise
   try
      nn.xregmodel=set(nn.xregmodel,Property,Value);
   catch
      try
         nn.param.(Property) = Value;
      catch
         lasterr
         error(strvcat(['NNMODEL/SET invalid property ',Property],lasterr));
      end
   end
   
end
if nargout==1
   varargout{1} = nn;
else
   assignin('caller', inputname(1), nn);
end
