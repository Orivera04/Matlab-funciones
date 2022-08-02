function disp(obj)
%DISP Display OPC Toolbox objects.
%   DISP(Obj) displays information for the OPC Toolbox object Obj.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.8 $  $Date: 2004/03/24 20:42:53 $

if length(obj)>1
    arraydisp(obj);
    return
elseif ~isvalid(obj)
   disp([...
         'Invalid dagroup object.', sprintf('\n'),...
         'This object should be removed from your workspace using CLEAR.',sprintf('\n')]);
   return
end

%%% Just get all object property values.
pv = get(obj);
fmtIndent = 13;
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
itmStr = sprintf('%d-by-1 daitem object', length(pv.Item));
parentStr = pv.Parent.Name;
updateStr = sprintf('%g', pv.UpdateRate);
deadBandStr = sprintf('%g%%', pv.DeadbandPercent);

%%% Display starts here.
fprintf(1, newline);
fprintf(1, 'Summary of OPC Data Access Group Object: %s\n', pv.Name);
fprintf(1, newline);
fprintf(1, '%sObject Parameters\n', spcHead);
fprintf(1, dispFmt, spcProp, 'Group Type', pv.GroupType);
fprintf(1, dispFmt, spcProp, 'Item', itmStr);
fprintf(1, dispFmt, spcProp, 'Parent', parentStr);
fprintf(1, dispFmt, spcProp, 'Update Rate', updateStr);
fprintf(1, dispFmt, spcProp, 'Deadband', deadBandStr);
fprintf(1, newline);
fprintf(1, '%sObject Status\n', spcHead);
fprintf(1, dispFmt, spcProp, 'Active', pv.Active);
fprintf(1, dispFmt, spcProp, 'Subscription', pv.Subscription);
fprintf(1, dispFmt, spcProp, 'Logging', pv.Logging);
fprintf(1, newline);
fprintf(1, '%sLogging Parameters\n', spcHead);
fprintf(1, dispFmt, spcProp, 'Records', ...
    sprintf('%d', pv.RecordsToAcquire));
fprintf(1, dispFmt, spcProp, 'Duration', sprintf('at least %g seconds', ...
    pv.RecordsToAcquire.*pv.UpdateRate));
fprintf(1, dispFmt, spcProp, 'Logging to', pv.LoggingMode);
if ~isempty(findstr('disk', pv.LoggingMode)),
    fprintf(1, dispFmt, spcProp, 'Log File', ...
        sprintf('%s (''%s'' mode)', pv.LogFileName, pv.LogToDiskMode));
end
if strcmp(pv.Logging, 'on'),
    logStatus = sprintf('%d records acquired since starting.', pv.RecordsAcquired);
else
    logStatus = sprintf('Waiting for START.');
end
fprintf(1, dispFmt, spcProp, 'Status', logStatus);
fprintf(1, nocFmt, spcProp, '', ...
    sprintf('%d records available for GETDATA/PEEKDATA', ...
    pv.RecordsAvailable));
fprintf(1, newline);