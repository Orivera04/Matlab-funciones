function UnitObj = junit(varargin)
%JUNIT/JUNIT  Constructor for unit objects.
%
%   UnitObj = JUNIT(UnitStr) constructs a junit object using a parsable string
%   UnitStr.  To construct a difference unit, append '(difference)' to
%   UnitStr, e.g. junit('m (difference)').
%
%   UnitObj = JUNIT(UnitStr, QuantityType) sets the quantity type(s) of the
%   junit object.
%
%   UnitObj = JUNIT constructs default (dimensionless) unit object.
%
%   To initialise JUNIT preferences:
%   JUNIT('SET-UNITNS', namespace) sets the namespace
%   JUNIT('SET-UNITDB', UnitDB) sets the units database
%
%   See also GET.

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 06:43:35 $

% ---------------------------------------------------------------------------
% Description : Method to construct a junit object
% Inputs      : UnitStr - parsable string (string, optional)
% Outputs     : UnitObj - junit object (junit)
% ---------------------------------------------------------------------------


persistent VERSION ORGANISATION MANAGER EMPTY_JUNIT

% Import the ucar.unit package (must be on the MATLAB classpath)
import ucar.units.*

% Import the com.mathworks.toolbox.mbc.units package (must be on the MATLAB classpath)
import com.mathworks.toolbox.mbc.units.*

if isempty(VERSION)
	
	VERSION= '0';
	ORGANISATION= 'The MathWorks';
	EMPTY_JUNIT= [];
	
    % Initialise units database, parser, etc
    % [VERSION, ORGANISATION, MANAGER, EMPTY_JUNIT] = initialise(varargin{:});

    mlock
end

if isempty(VERSION)
	JavaUnitObj=[];
	UnitStr='';
	Quantity = {};
	Difference = 0; % initialise
	isValid= false;

else
	Difference = 0; % initialise
	isValid= true;


	switch nargin
	case 0,
		% Construct a dimensionless units object
		UnitStr = '';
		Quantity = {};
	case 1
		u= varargin{1};
		if isstruct(u) | isa(u,'junit');
			% re-parse a junit or old structure from loadobj
			
			UnitStr= u.Constructor;
			Quantity= u.Quantity;
			Difference= u.Difference;
			
			
			% Some version control issues need to be addressed
			if(~strcmp(u.Organisation,ORGANISATION))
				% The unit was created with a database different from that currently available,
				% possible issues with incompatibility
				warning(['Attempt to load a junit from ' u.Organisation ...
						' using a junits database from ' ORGANISATION]);
			elseif(sscanf('%g',u.Version)>sscanf('%g',VERSION))
				% The unit was created with a newer database from that currently available,
				% possible issues with backward compatibility
				warning(['Unit created with ' u.Organisation ...
						' version ' u.Version ' units database, trying to load using ' , ...
						ORGANISATION, ' version ' VERSION ' units database']);
			end
			
		else
			% Error check on UnitStr
			UnitStr = strtrim(i_checkUnitStr(u));
			Quantity = {};
		end
	case 2,
		% Error check on UnitStr, Quantity
		UnitStr = strtrim(i_checkUnitStr(varargin{1}));
		Quantity = i_checkQuantity( varargin{2} );
	end

	try
		JavaUnitObj=[];
		Quantity = {};
		isValid= false;
		
% 		if ~isempty(UnitStr)
% 			% Create java junit object JavaUnitObj
% 			Difference = (length(UnitStr) >= 12);
% 			if Difference
% 				Difference = strcmp(UnitStr(end-11:end), '(difference)');
% 			end
% 			if Difference
% 				% Remove '(difference)', we will add it again later
% 				UnitStr = strtrim(UnitStr(1:end-12));
% 			end
% 			JavaUnitObj = MANAGER.parse(UnitStr);
% 		else
% 			JavaUnitObj = EMPTY_JUNIT;
% 		end
% 		if isempty(Quantity) 
% 			Quantity = {};
% 		else
% 			% Look for matches between specified and registered quantity types
% 			% Retrieve registered quantity types
% 			QuantityVector = QuantityType.getQuantityTypes(JavaUnitObj);
% 			ValidQuantity = {};
% 			for qcount = 1:length(Quantity),
% 				isValidQuantity = 0;
% 				qcomp= lower(Quantity{qcount});
% 				for rcount = 0:(QuantityVector.size)-1,
% 					if strcmp( lower(QuantityVector.elementAt(rcount)) , qcomp )
% 						ValidQuantity = [ValidQuantity {QuantityVector.elementAt(rcount)}];
% 						isValidQuantity = 1;
% 					end % if
% 				end % for rcount
% 				if isValidQuantity == 0
% 					warning([mfilename ': invalid quantity type ''' Quantity{qcount} ''' for unit ''' UnitStr '''']);
% 				end % if
% 			end % for qcount
% 			Quantity = ValidQuantity;
% 		end % if
		
	catch
		isValid= false;
		% Unable to parse unit string, error
		JavaUnitObj = [];
	end % try
	
	% Add '(difference)'
	if Difference
		UnitStr = strtrim([UnitStr ' (difference)']);
	end

end


% Define object structure
UnitObjStruct = struct('Java',JavaUnitObj,...
	'Quantity',{Quantity},...
	'Difference',Difference,...
	'Constructor',UnitStr,...
	'Organisation',ORGANISATION,...
	'Version',VERSION,...
	'IsValid',isValid,...
	'JUnitVer',2);

% Create object class
UnitObj = class(UnitObjStruct, 'junit');

% ---------------------------------------------------------------------------

function in = i_checkUnitStr(in)

if ~ischar(in)
	% UnitStr is not a character array, error
	error([mfilename ': UnitStr must be a string']);
elseif size(in,1)>1
	% UnitStr is valid, retain only the first row
	in = in(1,:);
end % if

% ---------------------------------------------------------------------------

function in = i_checkQuantity(in)

% Put the contents of Quantity in a 1 x n cell array of strings
if ~iscell(in)
	in = {in};
end % if
in = in(:)';
% Step through the elements of Quantity, checking for non-strings and
% removing empty cells
for qcount = length(in):-1:1,
	if isempty(in{qcount})
		% This element is empty, remove it from the cell array
		in(qcount) = [];
	elseif ~ischar(in{qcount})
		% This element is not a character array, error
		error([mfilename ': QuantityType must contain string(s)']);
	else
		% This element is valid, retain only the first row
		in{qcount} = in{qcount}(1,:);
	end % if
end % for

% ---------------------------------------------------------------------------

function str = strtrim(str)

if ~isempty(str)
	p= find(str~=32);
	if ~isempty(p)
		str= str(p(1):p(end));
	else
		str='';
	end
end
