function varargout = set(this, varargin)
%SET Configure or display OPC Toolbox object properties.
%   SET(Obj,'PropertyName',PropertyValue) sets the value, PropertyValue,
%   of the specified property, PropertyName, for OPC Toolbox object Obj.
%   Obj can be a vector of OPC Toolbox objects, in which case SET sets the
%   property values for all the OPC Toolbox objects specified.
%
%   Note that if Obj is connected to an OPC server, configuring
%   server-specific properties such as LanguageID, UpdateRate, and
%   DeadbandPercent might be time consuming.
%
%   SET(Obj,S) where S is a structure whose field names are object
%   property names, sets the properties named in each field name to the
%   values contained in the structure.
%
%   SET(Obj,PN,PV) sets the properties specified in the cell array of
%   strings, PN, to the corresponding values in the cell array PV for all
%   objects specified in Obj. The cell array PN must be a vector, but the
%   cell array PV can be M-by-N where M is equal to LENGTH(Obj) and N is
%   equal to LENGTH (PN) so that each object will be updated with a
%   different set of values for the list of property names contained in PN.
%
%   SET(Obj,'PropName1',PropValue1,'PropName2',PropValue2,...) sets
%   multiple property values with a single statement.
%
%   Note that it is permissible to use param-value string pairs,
%   structures, and param-value cell array pairs in the same call to SET.
%
%   SET(Obj,'PropertyName') and Prop = SET(Obj,'PropertyName') displays or
%   returns the possible values for the specified property, PropertyName,
%   of OPC Toolbox object Obj. The returned array, Prop, is a cell array
%   of possible value strings or an empty cell array if the property does
%   not have a finite set of possible string values.
%
%   SET(Obj) and Prop = SET(Obj) displays or returns all property names
%   and their possible values for OPC Toolbox object Obj. The return
%   value, Prop, is a structure whose field names are the property names
%   of Obj, and whose values are cell arrays of possible property values
%   or empty cell arrays.
%
%   Examples
%       da = opcda('localhost','Dummy.Server');
%       grp = addgroup(da,'SetExample');
%       set(da,'Timeout',300,'EventLogMax',2000);
%       set(da,{'Name','ServerID'},{'My Opcda object','OPC.Server.1'});
%       set(grp,'Name','myopcgroup');
%       set(grp,'Subscription')
%
%   See also OPCROOT/GET, PROPINFO, OPCHELP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/03/24 20:43:44 $


% Call builtin set if OBJ isn't an opcda object.
% Ex. set(gcf, obj);
if ~isa(this, 'opcroot') 
    builtin('set', this, varargin{:})
    return
end

% Error if invalid.
if ~all(isvalid(this)),
    rethrow(mkerrstruct('opc:set:objinvalid'));
end

if nargout == 0    
    if nargin == 1        
        % out = set(obj)
        if length(this)>1
            rethrow(mkerrstruct('opc:set:vecnotsupported'));
        else
             localSetListDisp(getudd(this));
        end
    else % set(obj, property)        
        try
            % Call the UDD set method.
            if (nargin == 2)
                if ischar(varargin{1}) 
                    % Ex. set(obj, 'LoggingMode')
                    % Obtain the property's enums (this also
                    % ensures we have a valid property).
                    enums = set(getudd(this), varargin{1});
                    
                    % Correct the case of the property name - i.e case
                    % insensitivity.
                    h = getudd(this);
                    handle = h.classhandle;
                    propinfo = findprop(handle, varargin{1});
                    
                    % Create the property's enum display.
                    fprintf(createpropenumdisp(propinfo.Name, enums, propinfo.FactoryValue));
                else
                    % Ex. set(obj, struct);
                    set(getudd(this), varargin{:})
                end
            else
                set(getudd(this), varargin{:})
            end
        catch
            fixudderror(this);
            rethrow(mkerrstruct(lasterror));
        end     
    end
elseif (nargout ==1) && (nargin==1) 
    % e.x. out = set(in)
    try
        % Call the UDD SET method and sort the list.
        outputStruct = set(getudd(this));
        fields = fieldnames(outputStruct);
        [sorted, ind] = sort(fields);
        for i=1:length(sorted),
            output.( fields{ind(i)} ) = outputStruct.( fields{ind(i)} );
        end
        if length(sorted)>0
            varargout{1} = output;
        end
    catch
        fixudderror(this);
        rethrow(mkerrstruct(lasterror));
    end
else
    % Ex. out = set(obj, 'LoggingMode')
    % Ex. out = set(obj, 'LogiingMode', 'on')
    try
        % Call the UDD set method.
        output = set(getudd(this), varargin{:});
        if nargin<=2,
            varargout{1} = output;
        end
    catch
        fixudderror(this);
        rethrow(mkerrstruct(lasterror));
    end
end     
                
% *******************************************************************
function localSetListDisp(uddobj)
% Create the SET display for SET(OBJ).
% Create a sorted list of PV pairs.

list = set(uddobj);
handle = uddobj.classhandle;

% Sort the properties into their property lists
switch uddobj.Type
    case 'opcda'
        propHeads = {...
            'General Properties', ...
            'Callback Function and Event Properties', ...
            'Server Connection Properties'};
        propHeadCount = [1, 6, 12];
        propOrder = {'Group', 'Name', 'Tag', 'Type', 'UserData', ...
            'ErrorFcn', 'EventLog', 'EventLogMax', 'ShutdownFcn', 'TimerFcn', 'TimerPeriod', ...
            'Host', 'ServerID', 'Status', 'Timeout'};
    case 'dagroup'
        propHeads = {...
            'General Properties', ...
            'Callback Function and Event Properties', ...
            'Subscription and Logging Properties'};
        propHeadCount = [1, 10, 18];
        propOrder = {'GroupType', 'Item', 'LanguageID', 'Name', 'Parent', ...
                'Tag', 'TimeBias', 'Type', 'UserData', ...
            'CancelAsyncFcn', 'DataChangeFcn', 'ReadAsyncFcn', ...
                'RecordsAcquiredFcn', 'RecordsAcquiredFcnCount', ...
                'StartFcn', 'StopFcn', 'WriteAsyncFcn', ...
            'Active', 'DeadbandPercent', 'LogFileName', 'Logging', ...
                'LoggingMode', 'LogToDiskMode', 'RecordsAcquired', ...
                'RecordsAvailable', 'RecordsToAcquire', 'Subscription', ...
                'UpdateRate'};
    case 'daitem'
        propHeads = {...
            'General Properties', ...
            'Data Properties'};
        propHeadCount = [1, 9];
        propOrder = {'AccessRights', 'Active', 'ItemID', 'Parent', ...
                'ScanRate', 'Tag', 'Type', 'UserData', ...
            'CanonicalDataType', 'DataType', 'Quality', 'TimeStamp', ...
                'Value'};
    otherwise
        % Throw an error?
        rethrow(mkerrstruct('opc:set:invalidtype'));
end

% Now display to a string

% Display each property as follows:
%   ...
%   LoggingMode: [ append | index | {overwrite} ]
%   Name
%   ...
indent = blanks(4);
halfInd = indent(1:end/2);
% We always start with the first category, so...
strToDisp = '';
for i=1:length(propOrder),
    headInd = (i==propHeadCount);
    if any(headInd),
        % Need to print the heading
        strToDisp = sprintf('%s\n%s%s:\n', strToDisp, halfInd, propHeads{headInd});
    end
    if isfield(list, propOrder{i}),
        thisVal = list.(propOrder{i});
        enumStr = '';
        propName = sprintf('%s%s', indent, propOrder{i});
        propertyinfo = findprop(handle, propOrder{i});
        if ~isempty(thisVal) || (length(propName)>3 && strcmp(propName(end-2:end),'Fcn'))
            enumDisp = createpropenumdisp(propOrder{i}, ...
                thisVal,propertyinfo.FactoryValue);
            enumStr = sprintf(': %s', enumDisp);
        end
        strToDisp = sprintf('%s%s%s\n', strToDisp, propName, enumStr);
    end
end
% Display properties in groups.
fprintf('%s\n', strToDisp);
