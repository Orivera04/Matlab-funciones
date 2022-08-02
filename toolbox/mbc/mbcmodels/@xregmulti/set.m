function varargout= set(m,prop,value);
% MULTIMODEL/SET overloaded set for xregcubic
%
% m= set(m,prop,value)
%   MULTIMODEL properties
%       Currentindex   :   index number of 'active' model
%       Currentmodel   :   model object
%       Currentweight  :   weighting factor (0<w<1)
%       Weights        :   vector of weights
%       Models         :   cell array of models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:54:08 $

% Created 25/5/2000


switch lower(prop)
case 'currentindex'
   if value>0 & value<=length(m.weights)
      m.currentindex=value; 
   end
   
case 'currentmodel'
   if get(value,'nfactors')==get(m,'nfactors')
      m.models{m.currentindex}=value;
   end
   
   
case 'currentweight'
   m.weights{m.currentindex}=value;
   m.weights=m.weights./sum(m.weights);
case 'weights'
   value=value(:)';
   if length(value)==length(m.weights)
      m.weights = value;
      sm=sum(m.weights);
      if sm
         m.weights=m.weights./sm;
      else
         m.weights = ones(1,length(m.weights))./length(m.weights);
      end
   end
case 'models'
   value=value(:)';
   if length(value)==length(m.weights)
      m.models = value;
   end
   % copy the model coding from the multimod parent to all contained models
   m=i_copymodel(m);
case 'allmodels'
   % bypasses model coding copying
   value=value(:)';
   if length(value)==length(m.weights)
      m.models = value;
   end
otherwise
   try
      % set properties on parent - need to copy parent to each contained model?
      m.xregmodel = set(m.xregmodel,prop,value);
      % copy the model coding from the multimod parent to all contained models
      m=i_copymodel(m);
   catch
      % set property on current model
      m.models{m.currentindex}=set(m.models{m.currentindex},prop,value);
   end
end

if nargout==1
   varargout{1}= m;
else
   assignin('caller',inputname(1),m)
end



function m=i_copymodel(m)

for n=1:length(m.models)
   m.models{n} = copymodel(m.xregmodel,m.models{n});
end