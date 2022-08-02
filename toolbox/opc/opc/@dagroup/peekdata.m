function s = peekdata(obj, nRec)
%PEEKDATA Preview most recently acquired data.
%   S = PEEKDATA(GObj, NRec) returns the NRec most recently acquired
%   records for the dagroup object, GObj, without removing those records
%   from the OPC Toolbox engine. GObj must be a scalar dagroup object. S
%   is a structure array containing data for each record, in the same
%   format as the structure returned by GETDATA.
%
%   If NRec is greater than the number of records currently available, a
%   warning will be generated and all available records will be returned.
%
%   You use PEEKDATA when you want to return logged data but you do not
%   want to remove the data from the buffer. The object's RecordsAvailable
%   property value will not be affected by the number of samples returned
%   by PEEKDATA.
%
%   PEEKDATA is a non-blocking function that immediately returns records
%   and execution control to the MATLAB workspace.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       grp = addgroup(da, 'ExOPCREAD');
%       itm1 = additem(grp, 'Triangle Waves.Real8');
%       itm2 = additem(grp, 'Saw-Toothed Waves.Int2');
%       set(grp, 'LoggingMode', 'memory', 'RecordsToAcquire', 60);
%       start(grp);
%       pause(2);
%       s = peekdata(grp, 2)
%       s.Items(1).Value
%       [itmID, val, qual, tStamp] = getdata(grp, 'double');
%       plot(tStamp(:,1),val(:,1), tStamp(:,2),val(:,2));
%       legend(itmID);
%       datetick x keeplimits
%
%   See also DAGROUP/FLUSHDATA, DAGROUP/GETDATA, DAGROUP/START, DAGROUP/STOP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/02/01 22:05:59 $

errorMsg = nargchk(2, 2, nargin);
if ~isempty(errorMsg),
    rethrow(mkerrstruct('opc:peekdata:inargs', errorMsg));
end

% Object must be a scalar
if length(obj) > 1
    rethrow(mkerrstruct('opc:getdata:vecnotsupported'));
end    
    
% Group must be valid
if ~isvalid(obj)
    rethrow(mkerrstruct('opc:peekdata:objinvalid'));
end

% NRec must be posInt
if nRec<1 || (rem(nRec, 1)>0),
    rethrow(mkerrstruct('opc:peekdata:nrecposint'));
end

try
    s = udpeekdata(getudd(obj),nRec); 
catch
    rethrow(mkerrstruct(lasterror));
end
