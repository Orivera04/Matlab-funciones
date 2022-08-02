function logRestore(this)
% Restores data logging info

% Author(s): P. Gahinet, Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:18 $

if ~isempty(this.DataLoggingSettings)
  % Restore model's data logging settings
  LogPorts  = this.DataLoggingSettings.LogPorts;
  LogStruct = this.DataLoggingSettings.LogStruct;
  
  set( this.DataLoggingSettings.LogPorts, 'DataLogging', 'on' )
  for ct = 1:length(LogPorts)
    lpct = LogPorts(ct);
    lsct = LogStruct(ct);
    
    set( lpct, 'TestPoint',           lsct.TestPoint, ...
               'DataLoggingName',     lsct.DataLoggingName, ...
               'DataLoggingNameMode', lsct.DataLoggingNameMode );
  end
  
  % Restore Dirty flag.  Do this last.
  set_param( this.Model, ...
             'SignalLoggingName', this.DataLoggingSettings.LogVar, ...
             'Dirty',             this.DataLoggingSettings.Dirty );
end
