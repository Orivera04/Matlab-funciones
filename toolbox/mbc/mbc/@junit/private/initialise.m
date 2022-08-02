function varargout = initialise(varargin)
%INITIALISE

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 06:43:51 $

%INITIALISE  Get and set units database, preferences.
% 
%   Private function used by junit/junit, junit/get.

% ---------------------------------------------------------------------------
% Description : Method to construct a junit object
% Inputs      : UnitStr - parsable string (string, optional)
% Outputs     : UnitObj - junit object (junit)
% ---------------------------------------------------------------------------

persistent VERSION ORGANISATION MANAGER EMPTY_JUNIT UNITDB UNITNS

% Import the ucar.unit package (must be on the MATLAB classpath)
import ucar.units.*

% Import the com.mathworks.toolbox.mbc.units package (must be on the MATLAB classpath)
import com.mathworks.toolbox.mbc.units.*

% Set global namespace
UnitXML.setWorldNamespace('http://www.mathworks.com/namespace');

% Turn off messages from the entity resolver
UnitXML.setResolverMessages(false);

% Provide a mechanism for getting and setting UNITDB and UNITNS
switch nargin
case 1
    if ischar(varargin{1}) & (size(varargin{1}, 1) == 1) & strcmp(varargin{1}, 'GET-UNITDB')
        % Get UNITBD
        varargout = {UNITDB};
        return
    elseif ischar(varargin{1}) & (size(varargin{1}, 1) == 1) & strcmp(varargin{1}, 'GET-UNITNS')
        % Get UNITNS
        varargout = {UNITNS};
        return
    end
case 2
    if ischar(varargin{1}) & (size(varargin{1}, 1) == 1) & strcmp(varargin{1}, 'SET-UNITDB')
        % Set UNITBD
        UNITDB = i_checkPreferenceStr(varargin{2});
        % disp(['Setting units database to: ' UNITDB]);
        varargout = {VERSION, ORGANISATION, MANAGER, EMPTY_JUNIT, UNITDB, UNITNS};
        return
    elseif ischar(varargin{1}) & (size(varargin{1}, 1) == 1) & strcmp(varargin{1}, 'SET-UNITNS')
        % Set UNITNS
        UNITNS = i_checkPreferenceStr(varargin{2});
        % disp(['Setting namespace to: ' UNITNS]);
        varargout = {VERSION, ORGANISATION, MANAGER, EMPTY_JUNIT, UNITDB, UNITNS};
        return
    end
end

% Set up default UNITDB
if isempty(UNITDB)
    UNITDB = 'http://www-internal.mathworks.com/~dsampson/units/dist/mwunit.xml';
end

% Set up default UNITNS
if isempty(UNITNS)
    UNITNS = strrep(fullfile(matlabroot, 'namespace'), filesep, '/');
    if ispc
        UNITNS = ['file:///' UNITNS];
    end
end

% Set local namespace
UnitXML.setLocalNamespace(UNITNS);

% Set XML location
StandardUnitDB.setUnitXML(UNITDB);
StandardUnitDB.setUnitXMLSearch('URL'); % the alternative is ('classpath')

% Create an instance manager of the UnitFormatManager class
manager = UnitFormatManager.instance;

% Store empty JUNIT for efficiency
EMPTY_JUNIT  = manager.parse('');

% Don't show parser errors
StandardUnitFormat.showParserErrors(0);

ORGANISATION = char(UnitXML.getOrganisation);
VERSION      = char(UnitXML.getVersion);
MANAGER      = manager;

varargout = {VERSION, ORGANISATION, MANAGER, EMPTY_JUNIT, UNITDB, UNITNS};

% ---------------------------------------------------------------------------

function in = i_checkPreferenceStr(in)

if ~ischar(in)
    % UnitStr is not a character array, error
    error([mfilename ': ' varname ' must be a string']);
elseif size(in,1)>1
    % UnitStr is valid, retain only the first row
    in = in(1,:);
end % if
