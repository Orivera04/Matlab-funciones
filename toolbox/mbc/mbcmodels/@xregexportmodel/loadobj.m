function EM= loadobj(EMold)
% ExportModel\loadobj
% Before Dec 2000 Exportmodel was a container class and after Dec 2000 it is a parent class.
% Detect old ExportModels, extract the contained object and create a new child class
% (which will be parented by a new ExportModel)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:47:34 $

if isa(EMold , 'struct')
	if isfield(EMold , 'model')
		if iscell(EMold.model) 
			if length(EMold.model) == 1
				EMold.model = EMold.model{1};
			else
				EM = [];
				return
			end
        elseif isstruct(EMold.model)
            %No loadobj was triggered to convert an old model type
            EM = [];
            return
        end
	else
		EM = [];
		return
	end
	if isfield(EMold , 'name')
		name = EMold.name;
	else
		name = [];
	end	
	if isfield(EMold , 'information')
		information = EMold.information;
	else
		information = [];
	end	
	if isfield(EMold , 'constraints')
%		constraints = EMold.constraints;
% 18-12-00, set constraints field to be empty pending further decisions as to how best to imnplement and use this property-MH
        constraints = [];
	else
		constraints = [];
	end	
	if isfield(EMold , 'UpperRange') & isfield(EMold , 'LowerRange')
		ranges = [EMold.LowerRange(:)';EMold.UpperRange(:)'];
	else		
		try
			[Low,Upp] = range(EMold.model);
			ranges = [Low,Upp];
		catch
			ranges = [];
		end
	end
	% Found all the information we need, now construct the appropriate child object
	if isa(EMold.model,'xregmodel')
		EM = xregstatsmodel(EMold.model,name,information,constraints);
	elseif isa(EMold.model,'slmod')
		% Defunct class, all old instances of SLMod won't work on loading anyway
		EM = [];
	elseif isa(EMold.model,'funcmod')
		EM = cgfuncmodel(EMold.model,name,information,constraints,ranges);
	else
		if isa(EMold.model,'eqmod') | isa(EMold.model,'tablemod')
			EM = cgexprmodel(EMold.model,name,information,constraints,ranges);
		else
			% must have been converted ok already
			EM = EMold.model;
			EM.name = name;
			EM.information = information;
			EM.constraints = constraints;
			EM = setranges(EM,ranges);
		end
	end
else
	EM=EMold;
end

