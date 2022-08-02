function logSave(this)
% Saves initial data logging settings for Simulink model, and turn off all
% data logging ports.

% Author(s): P. Gahinet, Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:19 $

Model = this.Model;

% Get model's data logging settings
LogVar = get_param(Model, 'SignalLoggingName');

LogPorts = find_system( this.Model, 'FindAll', 'on', ...
                        'FollowLinks', 'on', 'LookUnderMasks', 'all', ...
                        'Type', 'port',  'PortType','outport', ...
                        'DataLogging', 'on' );

LogStruct = struct( ...
    'TestPoint',           get(LogPorts, {'TestPoint'}), ...
    'DataLoggingName',     get(LogPorts, {'DataLoggingName'}), ...
    'DataLoggingNameMode', get(LogPorts, {'DataLoggingNameMode'}) );

% Store logging data for later retrieval
this.DataLoggingSettings = struct( 'LogVar',    LogVar, ...
                                   'LogPorts',  LogPorts, ...
                                   'LogStruct', LogStruct, ...
                                   'Dirty',     get_param(Model, 'Dirty') );

set( LogPorts, 'DataLogging', 'off', 'TestPoint', 'off' )
set_param( Model, 'SignalLoggingName', 'SPE_DataLog' )
