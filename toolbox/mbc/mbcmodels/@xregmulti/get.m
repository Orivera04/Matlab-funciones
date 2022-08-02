function val= get(m,prop);
% MULTIMODEL/GET overloaded get for xregcubic
%
% val= get(m,prop)
%   MULTIMODEL properties
%       Currentindex   :   index number of 'active' model
%       Currentmodel   :   current active model
%       Currentweight  :   current active weight
%       nmodels        :   number of contained models
%       Models         :   cell array of all models
%       Weights        :   vector of all weights

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:54:02 $

% Created 25/5/2000

if nargin==1
	val= [{'currentindex','currentmodel','currentweight','nmodels',...
			'models','weights','maxterms'}';get(m.xregmodel)];
else
	
	switch lower(prop)
	case 'currentindex'
		val=m.currentindex;
	case 'currentmodel'
		val=m.models{m.currentindex}; 
	case 'currentweight'
		val=m.weights{m.currentindex};
	case 'nmodels'
		val=length(m.weights);
	case 'models'
		val=m.models;   
	case 'weights'
		val=m.weights;
	case 'maxterms'
		% return number of terms in biggest model
		val=0;
		for n=1:length(m.weights)
			val=max(val,NumTerms(m.models{n}));
		end
	otherwise
		% get properties from parent, then current model
		try
			val= get(m.xregmodel,prop);
		catch
			val= get(m.models{m.currentindex},prop);
		end
	end
end
