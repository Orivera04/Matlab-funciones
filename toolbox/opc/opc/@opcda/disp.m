function disp(obj)
%DISP Display OPC Toolbox objects.
%   DISP(Obj) displays information for the OPC Toolbox object Obj.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.8 $  $Date: 2004/03/24 20:43:11 $

if length(obj)>1
    arraydisp(obj);
    return
elseif ~isvalid(obj)
   disp([...
         'Invalid opcda object.', sprintf('\n'),...
         'This object should be removed from your workspace using CLEAR.',sprintf('\n')]);
   return
end

%%% Just get all object property values.
pv = get(obj);
fmtIndent = 10;
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
grpStr = sprintf('%d-by-1 dagroup object', length(pv.Group));
timeoutStr = sprintf('%g seconds', pv.Timeout);
eventsStr = sprintf('%d of %d events', length(pv.EventLog), pv.EventLogMax);
%%% Display starts here.
fprintf(1, newline);
fprintf(1, 'Summary of OPC Data Access Client Object: %s\n', pv.Name);
fprintf(1, newline);
fprintf(1, '%sServer Parameters\n', spcHead);
fprintf(1, dispFmt, spcProp, 'Host', pv.Host);
fprintf(1, dispFmt, spcProp, 'ServerID', pv.ServerID);
fprintf(1, dispFmt, spcProp, 'Status', pv.Status);
fprintf(1, dispFmt, spcProp, 'Timeout', timeoutStr);
fprintf(1, newline);
fprintf(1, '%sObject Parameters\n', spcHead);
fprintf(1, dispFmt, spcProp, 'Group', grpStr);
fprintf(1, dispFmt, spcProp, 'Event Log', eventsStr);
fprintf(1, newline);