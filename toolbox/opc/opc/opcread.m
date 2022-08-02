function varargout = opcread(fileName,varargin)
%OPCREAD Return logged records from disk to MATLAB workspace.
%   S=OPCREAD('LogFileName') returns all available records from the OPC
%   log file named LogFileName. If no extension is specified as part of
%   LogFileName, then .olf is used.
%
%   S is an NRec-by-1 structure array, where NRec is the number of records
%   returned. S contains the fields LocalEventTime and Items.
%   LocalEventTime is a date vector corresponding to the local event time
%   for that record. Items is an NItems-by-1 structure array containing
%   the fields:
%       'ItemID' - The fully qualified tag name, as a string.
%       'Value' - The data value. The data type is dependent on the 
%           original Item's DataType property.
%       'Quality' - The data quality, as a string.
%       'TimeStamp' - The time the value was changed, as a date vector.
%
%   S=OPCREAD('LogFileName','PropertyName','PropertyValue',...) limits the
%   data read from the specified OPC log file based on the properties and
%   values provided. Valid Property Names and Property Values include:
%       'Records' - Specify the required records as [startRec endRec]. If 
%           no records fall within those bounds, OPCREAD returns empty 
%           outputs.
%       'Dates' - Specify the date range for records as [startDt endDt]. 
%           The dates must be in MATLAB date number format. If no records 
%           fall within those bounds, OPCREAD returns empty outputs.
%       'ItemIDs' - Specify the required ItemIDs as a string or cell array 
%           of strings. If no records match the required ItemID, OPCREAD 
%           returns empty outputs.
%
%   [ItmID,Val,Qual,TStamp,ETime]=OPCREAD('LogFileName','DataType',DType,...)
%   assigns the data retrieved from the OPC Log File to separate arrays.
%   DType can be any valid MATLAB numeric data type (such as 'double' or
%   'uint4'), or 'cell'.
%
%   ItmID is a 1-by-NItem cell array of item names.
%
%   Val is an NRec-by-NItem array of values with the data type specified.
%   If a data type of 'cell' is specified, then Val is a cell array
%   containing data in the returned data type for each item. Otherwise,
%   Val is a numeric array of the specified data type. Note that DType
%   must be set to 'cell' when retrieving records containing arrays of
%   values, and strings.
%
%   Qual is an NRec-by-NItem array of quality strings for each value in
%   Val.
%
%   TStamp is an NRec-by-NItem array of MATLAB date numbers representing
%   the time when the relevant value and quality were stored on the OPC
%   Server.
%
%   ETime is an NRec-by-1 array of MATLAB date numbers, corresponding to
%   the local event time for each record.
%
%   Each record logged may not contain information for every item
%   returned, since data for that item may not have changed from the
%   previous update. When data is returned as a numeric matrix, the
%   missing item columns for that record are filled as follows:
%       'Val' - The corresponding value entry is set to the previous value 
%           of that item, or to NaN if there is no previous value.
%       'Qual' - The corresponding quality entry is set to 'Repeat'.
%       'TStamp' - The corresponding time stamp entry is set to the first
%           valid time stamp for that record.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       grp = addgroup(da, 'ExOPCREAD');
%       itm1 = additem(grp, 'Triangle Waves.Real8');
%       itm2 = additem(grp, 'Saw-Toothed Waves.Int2');
%       set(grp, 'LoggingMode', 'disk', 'RecordsToAcquire', 30);
%       set(grp, 'LogFileName', 'ExOPCREAD.olf');
%       start(grp);
%       wait(grp);
%       s = opcread('ExOPCREAD.olf', 'Records', [1, 2]);
%       [itmID, val, qual, tStamp] = opcread('ExOPCREAD.olf', ...
%           'DataType', 'double');
%       plot(tStamp(:,1),val(:,1), tStamp(:,2),val(:,2));
%       legend(itmID);
%       datetick x keeplimits
%
%   See also DAGROUP/GETDATA, DAGROUP/START, DAGROUP/STOP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/03/24 20:43:37 $

% Number of arguments: Max 9 (filename plus 4 PV pairs)
errorargmsg = nargchk(1,9,nargin);
if ~isempty(errorargmsg)
    rethrow(mkerrstruct('opc:opcread:inargs',errorargmsg))
end
% Filename must be a string
if ~ischar(fileName)
    rethrow(mkerrstruct('opc:opcread:filenamearg'));
end    
% If filename has no extension, add .olf
[p, n, e] = fileparts(fileName);
if isempty(e),
    fileName = sprintf('%s.olf', fileName);
end
% Error if filename does not exist
if ~exist(fileName, 'file'),
    rethrow(mkerrstruct('opc:opcread:filenotfound'));
end
% Additional arguments: We just check them, and throw them all at the
% udopcread method.
wantsStruct = true;
if mod(length(varargin),2)~=0,
    rethrow(mkerrstruct('opc:opcread:pvmismatch'));
end
for k=1:2:length(varargin)
    if ~ischar(varargin{k}),
        rethrow(mkerrstruct('opc:opcread:propinvalid'));
    end
    val = varargin{k+1};
    switch lower(varargin{k})
        case 'records'
            % Make sure there are 2 integers
            if length(val)~=2 || any(val<=0) || ((val(2)-val(1))<0)
                rethrow(mkerrstruct('opc:opcread:recordsarg'));
            end
        case 'datatype'
            % Check that it's a valid data type
            validTypes = {'struct', 'cell', ...
                'double', 'single', ...
                'uint8', 'uint16', 'uint32', ...
                'int8', 'int16', 'int32', ...
                'logical'};
            if ~ischar(val) || ~any(strcmp(val, validTypes)),
                rethrow(mkerrstruct('opc:opcread:datatypeinvalid'));
            end
            wantsStruct = false;
            if strcmp(val, 'struct')
                wantsStruct = true;
                if nargout>1,
                    rethrow(mkerrstruct('opc:opcread:outputstoomany'));
                end
            end
        case 'dates'
            % Make sure there are 2 integers
            if length(val)~=2 || any(val<=0) || (val(2)-val(1))<=0
                rethrow(mkerrstruct('opc:opcread:datesarg'));
            end
        case 'itemids'
            if ischar(val)
                % Convert to a cell string
                varargin{k+1}=cellstr(val);
            elseif ~iscellstr(val)
                rethrow(mkerrstruct('opc:opcread:itemidbad'));
            end
        otherwise
            rethrow(mkerrstruct('propinvalid', sprintf('Invalid property ''%s''.', varargin{k})));
    end
end
% Check output args
if wantsStruct && nargout>1,
    rethrow(mkerrstruct('opc:opcread:outputstoomany'));
end
% Read data
try
    [varargout{1:max(nargout, 1)}] = opcmex('opcread', fileName, varargin{:});
catch
    rethrow(mkerrstruct(lasterror));
end
