function M= xregstatsmodel(m,name,i,constraints)
%XREGSTATSMODEL Internal function used to create a new xregstatsmodel
%
%  M = XREGSTATSMODEL returns an empty exportmodel object.
%
%  M = XREGSTATSMODEL(Model, Name, Info) returns an xregStatsModel object
%  containing a model object and traceability information.  Model must be
%  an xregmodel object.  Info is a structure with the following fields:
%    User      - User who created model.
%    Date      - Date created.
%    Version   - Version of MBC used.
%    Parent    - Name of parent project file.
%    Variables - Model variables.
%    new       - Structure with at least one field.  new{1} will contain
%                the emdidata for the engine. new{i}, i>1 will be a
%                structure with two fields, Title and Description, which
%                the user creates during the export model process.
%
%  M = XREGSTATSMODEL(Model, Name, Info, Constraints) will produce an
%  xregStatsModel with a non-empty constraints field.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.6 $  $Date: 2004/02/09 07:58:03 $

if nargin == 0
	M = struct('mvModel',[]);
	E = xregexportmodel;
elseif nargin > 0
	M.mvModel = m;
	% Exportmodel requires
	% (name,i,symbols,units,ranges,constraints)
	% so we need to manufacture symbols, units, ranges
	
	[unused,Symbols,U] = nfactors(m);
	U = reshape(U,length(U),1);
	% nfactors gives us input units
	yinf = yinfo(m);
	U = [{yinf.Units};U]; % first element is output units
	[Low,Upp]=range(m);
	R = [Low(:)';Upp(:)'];
	
	if nargin < 4	
		i = [];
		name = [];
		constraints = [];
	end
	E = xregexportmodel(name,i,Symbols,U,R,constraints);
end

M = class(M,'xregstatsmodel',E);
