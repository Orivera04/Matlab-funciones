function varargout = getdata(obj,varargin)
%GETDATA Return logged records from OPC Toolbox engine to MATLAB workspace.
%   S=GETDATA(GObj) returns the number of records specified in the
%   RecordsToAcquire property of dagroup object GObj, from the OPC Toolbox
%   engine. GObj must be a scalar dagroup object.
%
%   S is an NRec-by-1 structure array, where NRec is the number of records
%   returned. S contains the fields 'LocalEventTime' and 'Items'.
%   LocalEventTime is a date vector corresponding to the local event time
%   for that record. Items is an NItems-by-1 structure array containing
%   the fields:
%       'ItemID' - The fully qualified tag name, as a string.
%       'Value' - The data value. The data type is defined by the Item's
%           DataType property.
%       'Quality' - The data quality, as a string.
%       'TimeStamp' - The time the value was changed, as a date vector.
%
%   S=GETDATA(GObj,NRec) retrieves the first NRec records from the OPC
%   Toolbox engine.
%
%   [ItmID,Val,Qual,TStamp,ETime]=GETDATA(GObj,'DataType') and
%   [ItmID,Val,Qual,TStamp,ETime]=GETDATA(GObj,NRec,'DataType') assigns
%   the data retrieved from the OPC Toolbox engine to separate arrays.
%   'DataType' can be any valid MATLAB numeric data type (such as 'double'
%   or 'uint4'), or 'cell'.
%
%   ItmID is a 1-by-NItem cell array of item names.
%
%   Val is an NRec-by-NItem array of values with the data type specified.
%   If a data type of 'cell' is specified, then Val is a cell array
%   containing data in the returned data type for each item. Otherwise,
%   Val is a numeric array of the specified data type. Note that
%   'DataType' must be set to 'cell' when retrieving records containing
%   arrays of values, and strings.
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
%   GETDATA is a blocking function that returns execution control to the
%   MATLAB workspace when one of the following conditions are met:
%   - The requested number of records becomes available.
%   - The logging operation is automatically stopped by the engine. If
%     fewer records are available than the number requested, a warning will
%     be generated and all available records will be returned.
%   - You issue a ^C (Control-C). The logging task will not stop, and no
%     data will be removed from the OPC Toolbox engine.
%
%   When GETDATA completes, the object's RecordsAvailable property is
%   reduced by the number of records returned by GETDATA.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       grp = addgroup(da, 'ExOPCREAD');
%       itm1 = additem(grp, 'Triangle Waves.Real8');
%       itm2 = additem(grp, 'Saw-Toothed Waves.Int2');
%       set(grp, 'LoggingMode', 'memory', 'RecordsToAcquire', 60);
%       start(grp);
%       s = getdata(grp, 2)
%       [itmID, val, qual, tStamp] = getdata(grp, 'double');
%       plot(tStamp(:,1),val(:,1), tStamp(:,2),val(:,2));
%       legend(itmID);
%       datetick x keeplimits
%
%   See also DAGROUP/FLUSHDATA, DAGROUP/PEEKDATA, DAGROUP/START, DAGROUP/STOP.
   
% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.5 $  $Date: 2004/03/24 20:42:55 $

% Number of arguments
errorargmsg = nargchk(1,3,nargin);
if ~isempty(errorargmsg)
    rethrow(mkerrstruct('opc:getdata:inargs',errorargmsg))
end
% Object must be a scalar
if length(obj) > 1
    rethrow(mkerrstruct('opc:getdata:vecnotsupported'));
end    
% Group must be valid
if ~isvalid(obj)
    rethrow(mkerrstruct('opc:getdata:objinvalid'));
end
% Additional arguments:
nRec = get(obj, 'RecordsToAcquire');  % Default value
dataType = 'struct';    % Default value
if ~isempty(varargin) && ischar(varargin{end}),
    dataType = varargin{end};
    varargin(end)=[];
end
if length(varargin)>0,
    nRec = varargin{1};
end
% Now we can error check nRec
if ~isnumeric(nRec),
    rethrow(mkerrstruct('opc:getdata:nrecnumeric'));
end
nRec = double(nRec);    % Just make sure!
if length(nRec)>1 || floor(nRec)~=nRec || nRec < 0,
    rethrow(mkerrstruct('opc:getdata:nrecposint'));
end
if (nRec > get(obj, 'RecordsToAcquire'))
    rethrow(mkerrstruct('opc:getdata:nrectoolarge'));
end
% And error check the datatype
validTypes = {'struct', 'cell', ...
    'double', 'single', 'logical', ...
    'uint8', 'uint16', 'uint32', ...
    'int8', 'int16', 'int32'};
if ~any(strcmp(dataType, validTypes)),
    rethrow(mkerrstruct('opc:getdata:datatypeinvalid'));
end
if strcmp(dataType, 'struct') && nargout>1,
    rethrow(mkerrstruct('opc:getdata:outputstoomany'));
end
% Get data
try
    [varargout{1:max(nargout, 1)}] = udgetdata(getudd(obj),nRec,dataType);
catch
    rethrow(mkerrstruct(lasterror));
end
