function varargout = get(opcobj, varargin)
%GET Get OPC Toolbox object properties.
%   V = GET(Obj,'PropName') returns the value V of the property specified
%   by PropName for the OPC Toolbox object Obj.
%
%   If PropName is a cell array of strings containing property names, then
%   GET will return a 1-by-N cell array of values, where N is the length
%   of PropName. If Obj is a vector of OPC Toolbox objects, then V will be
%   an M-by-N cell array of property values where M is equal to the length
%   of Obj and N is equal to the number of properties requested.
%
%   GET(Obj) displays all property names and their current values for the
%   OPC Toolbox object Obj.
%
%   V = GET(Obj) returns a structure, V, where each field name is the name
%   of a property of Obj containing the value of that property. If Obj is
%   an array of OPC Toolbox objects, V will be a M-by-1 structure array.
%
%   Examples
%       da = opcda('localhost','Dummy.Server');
%       get(da, {'Status','Group'})
%       out = get(da,'Status')
%       get(da)
%
%   See also OPCROOT/SET, OPCROOT/PROPINFO, OPCHELP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/03/24 20:43:27 $

% Call builtin get if OBJ isn't an opc object.
% Ex. get(gcf, obj);
if ~isa(opcobj, 'opcroot')
    try
        out1 = builtin('get', opcobj, varargin{:});
    catch
        % Don't parse this, it's not one of ours!
        rethrow(lasterror)
    end
    varargout={out1};
    return
end
if nargin>2
    rethrow(mkerrstruct('opc:get:inputstoomany'));
end
if ~all(isvalid(opcobj))
    rethrow(mkerrstruct('opc:get:objinvalid'));
end

thisudd = getudd(opcobj);
if nargin == 1 && nargout == 0
    % get(obj)
    if length(thisudd)>1  
        rethrow(mkerrstruct('opc:get:vecnotsupported'));
    end
    localCreateGetDisplay(thisudd);
elseif (nargin == 1) && (nargout == 1)
    % out = get(obj)
        % Call the UDD GET method and sort the list.
        getStruct = get(thisudd);
        for nthStruct = 1:length(thisudd),
            fields = fieldnames(getStruct(nthStruct));
            [sorted, ind] = sort(fields);
            for i=1:length(sorted),
                output(nthStruct, 1).( fields{ind(i)} ) = getStruct(nthStruct).( fields{ind(i)} );
            end
        end
else   
    try
        output = get(thisudd, varargin{1});
    catch
        %TODO: Merge FIXUDDERROR with MKERRSTRUCT
        fixudderror(opcobj);
        rethrow(mkerrstruct(lasterror))
    end
end

% Assign the output for the case of:
%
%   A) out = get(obj);
%   B) out = get(obj, PropertyInput)
%   C) get(obj, PropertyInput)

syntaxA = (nargout==1) & (nargin==1);
syntaxBC = nargin==2;
if syntaxA || syntaxBC,
    out = output;
    if length(out) == 1 && strcmp(class(out),'cell')
       out = out{:};
    end    
    varargout{1} = out;
end



% ***************************************************************
% Create the GET display.
function localCreateGetDisplay(uddobj)

% Get the values
getStruct = get(uddobj);

% Sort the properties into their property lists
switch uddobj.Type
    case 'opcda'
        propHeads = {...
            'General Properties', ...
            'Callback Function and Event Properties', ...
            'Server Connection Properties'};
        propHeadCount = [1, 6, 12];
        propOrder = {'Group', 'Name', 'Tag', 'Type', 'UserData', ...
            'ErrorFcn', 'EventLog', 'EventLogMax', 'ShutdownFcn', ...
                'TimerFcn', 'TimerPeriod', ...
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
        rethrow(mkerrstruct('opc:get:invalidtype'));
end

% Capture UDD's GET structure display.
% This provides us with a formated display of a property's value.
uddGetDisp = evalc('disp(getStruct)');

strToDisp = '';
cr = sprintf('\n');
CRind = findstr(uddGetDisp, cr);
indent = blanks(4);
halfInd = indent(1:end/2);
% Deal with compact display.
if CRind(end)~=length(uddGetDisp),
    CRind(end+1)=length(uddGetDisp);
end
for i=1:length(propOrder),
    % Do we need to show a header?
    headInd = (i==propHeadCount);
    if any(headInd),
        % Need to print the heading
        strToDisp = sprintf('%s\n%s%s:\n', strToDisp, halfInd, propHeads{headInd});
    end
    if isfield(getStruct, propOrder{i}),
        % Extract the property name and its actual value.
        property = propOrder{i};
        value = getStruct.(property);

        % For strings, display the value to avoid having extra quotes.
        % For all other types, use the formatted value display from
        % the GET structure display.
        if ~ischar(value)
            % No CR for non-chars
            cr = '';

            % Locate the start and end of the property's value in
            % the GET structure display.
            startind = findstr(uddGetDisp, [' ' property ':']) + length(property) + 3;
            crToEnd = CRind(CRind>startind);

            % Extract the property's value from the GET structure display.
            value = uddGetDisp(startind:crToEnd(1)-1);
        end

    end
    % Create the PV line.
    strToDisp = sprintf('%s    %s = %s\n', strToDisp, property, value);
end
% Display properties in group.
fprintf('%s\n', strToDisp);
