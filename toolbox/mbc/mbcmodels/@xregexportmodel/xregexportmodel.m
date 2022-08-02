function M=xregexportmodel(name,i,symbols,units,ranges,constraints,varargin);
% xregexportmodel Abstract class constructor
%   expmod = xregexportmodel
%		Returns an empty exportmodel object
%   expmod = xregexportmodel(name,info)
%		Returns an xregexportmodel object containing traceability information.
%		info is a structure with the following fields
%			User - User who created model.
%           Date - Date created.
%           Version - Version of MBC used.
%           Parent - Name of parent project file.
%           Variables - Model variables.
%           new - Strucure with two fields, Title and Description,
% 				  (user defined information)
% expmodel = xregexportmodel(name,i,symbols,units,ranges,constraints)
% 			where all the additional fields must be cell arrays of length = number of inputs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:47:51 $



M = struct('name',[],...
	'information',[],...
	'symbols',[],...
	'units',[],...
	'ranges',[],...
	'constraints',[]);
if nargin > 0;
	M.name = name;
	if nargin > 1
		M.information=i;
		if nargin > 2
			M.symbols = symbols;
			if nargin > 3
				M.units = units;
				if nargin > 4
					M.ranges=ranges;
					if nargin > 5
						M.constraints = constraints;
					end
				end
			end
		end	
	end
end
M=class(M,'xregexportmodel');
