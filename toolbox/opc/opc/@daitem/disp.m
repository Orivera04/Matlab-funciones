function disp(obj)
%DISP Display OPC Toolbox objects.
%   DISP(Obj) displays information for the OPC Toolbox object Obj.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.8 $  $Date: 2004/03/24 20:43:03 $

if length(obj)>1
    arraydisp(obj);
    return
elseif ~isvalid(obj)
   disp([...
         'Invalid daitem object.', sprintf('\n'),...
         'This object should be removed from your workspace using CLEAR.',sprintf('\n')]);
   return
end

%%% Just get all object property values.
pv = get(obj);
fmtIndent = 14;
dispFmt = ['%s%-', int2str(fmtIndent), 's: %s\n'];
nocFmt = ['%s%-', int2str(fmtIndent), 's  %s\n'];
spcHead = blanks(3);
spcProp = blanks(6);
if strcmpi(get(0,'FormatSpacing'), 'loose'),
    newline = '\n';
else
    newline = '';
end

% Special formatting of some properties
% Value: Convert to a display string
fmtString = ''; % If empty at the end of the switch, conversion is done.
maxStrLen = 60;
switch pv.DataType
    case 'unknown'         % empty: disconnected
        valStr = '';
    case {'double', 'single'}
        fmtString = '%g';
    case 'char'
        % May be a cell array
        if iscell(pv.Value),
            % Make up the cell array of strings
            newDispStr = deblank(fliplr(deblank(fliplr(evalc('disp(pv.Value)')))));
            if length(newDispStr)>maxStrLen,
                % Need to make it the short version
                newDispStr = sprintf('{1x%d cell}', length(pv.Value));
            end
            valStr = newDispStr;
        else
            valStr = sprintf('%s', pv.Value);
        end
    case {'int8', 'int16', 'int32', 'uint8', 'uint16', 'uint32'}
        fmtString = '%d';
    case 'date',
        valStr = datestr(pv.Value, 0);
    case 'currency',
        fmtString = '%.2f';
    case 'logical'
        fmtString = '%d';
    otherwise
        valStr = sprintf('[Incompatible data type ''%s'']', ObjVals{4});
end
if ~isempty(fmtString),
    % Be sure to handle arrays gracefully!
    valStr = makearraystring(fmtString, double(pv.Value), maxStrLen);
end
% convert datevec to string
if isempty(pv.TimeStamp),
    timeStampStr='';
else
    timeStampStr = datestr(pv.TimeStamp,0);
end

%%% Display starts here.
fprintf(1, newline);
fprintf(1, 'Summary of OPC Data Access Item Object: %s\n', pv.ItemID);
fprintf(1, newline);
fprintf(1, '%sObject Parameters\n', spcHead);
fprintf(1, dispFmt, spcProp, 'Parent', get(pv.Parent, 'Name'));
fprintf(1, dispFmt, spcProp, 'Access Rights', pv.AccessRights);
fprintf(1, newline);
fprintf(1, '%sObject Status\n', spcHead);
fprintf(1, dispFmt, spcProp, 'Active', pv.Active);
fprintf(1, newline);
fprintf(1, '%sData Parameters\n', spcHead);
fprintf(1, dispFmt, spcProp, 'Data Type', pv.DataType);
fprintf(1, dispFmt, spcProp, 'Value', valStr);
fprintf(1, dispFmt, spcProp, 'Quality', pv.Quality);
fprintf(1, dispFmt, spcProp, 'Timestamp', timeStampStr);
fprintf(1, newline);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str = makearraystring(fmt, val, maxLen)
% Makes an array string from values returned by the OPC Toolbox
if length(val)>1,
    innerStr = sprintf(sprintf('%s ', fmt), val);
    str = sprintf('[%s]', innerStr(1:end-1));
else
    str = sprintf(fmt, val);
end
if length(str)>maxLen,
    str = sprintf('%dx1 %s', length(val), class(val));
end