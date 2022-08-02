% HDLDAEMON control server to support link to HDL simulators
%    HDLDAEMON controls the server that supports interactions with HDL simulators.
%
% Starting the server
% 
%    When starting the server, HDLDAEMON returns immediately.  The server runs in 
%    the background and will be available until either the server is explicitly 
%    stopped or MATLAB is closed. Only one server can run at a time for a given 
%    instance of MATLAB.  If you attempt to start a server when one is already 
%    running, the old server shuts down before the new one is started. 
%
%    To communicate with HDL simulators, the server uses one of two interprocess 
%    communication methods: shared memory (the default), or TCP/IP sockets. 
%    Communication by shared memory is usually faster than sockets.  When using 
%    shared memory, the server can communicate with only one HDL simulator at a 
%    time, and the HDL simulator must be running on the same host.  When using 
%    sockets, the server can communicate with multiple HDL simulators 
%    simultaneously, running on the same host or other hosts. 
% 
%    HDLDAEMON   - Start the Link for ModelSim MATLAB server using shared memory 
%    interprocess communication
% 
%    S=HDLDAEMON - Starts the server using shared memory interprocess
%    communication, and returns server status (see HDLDAEMON('status') command
%    below).
% 
%    HDLDAEMON('socket',port)   - Starts the server using socket interprocess
%    communication.  Port defines the TCP/IP port used for communication.  Can be:
%       - an explicit port number (1024 < port < 49151);
%       - 0, indicating the host should automatically chose a valid TCP/IP port;
%       - a service name (i.e. alias) from /etc/services file.
% 
%    S=HDLDAEMON('socket',port) - Starts the server using socket interprocess
%    communication, and returns server status (see HDLDAEMON('status') command
%    below).
% 
%    Examples:
%         'socket',4546 - Open server on port 4546
%         'socket','matlab' - Open server on port defined by 'matlab' service
%         'socket',0 - Allows system to assign TCP/IP port.  The actual port used
%         is returned in the status structure (see HDLDAEMON('status') command
%         below).
% 
%    Optional daemon properties for either shared memory or sockets:
%    'time' - Specifies how time values are returned by hdldaemon.  By
%        default, simulation time and VHDL time variables are converted
%        into seconds (represented by a double-precision value, and
%        therefore limited to 52 signficant bits).   To use the full
%        64 bit representation of time, set this property to 'int64' and
%        all time values will be returned as integer multiples of the
%        simulation resolution limit.
%    Examples:
%        'time','sec'   - (default) return doubles containing time in seconds
%        'time','int64' - return 64-bit integers containing time in
%                         multiples of simulation resolution
% 
% Stopping the server
% 
%    HDLDAEMON ('kill') or
%    HDLDAEMON ('stop')  - Terminate execution of the hdldaemon server
% 
% Getting server status
% 
%    HDLDAEMON ('status') - Display status of hdldaemon server
%    S=HDLDAEMON ('status') - Display status and return status in structure S
%        For shared memory:
%           S.comm = 'shared memory'
%           S.connections = number of open connections
%           S.ipc_id = file system name for the shared memory
%                      communication channel
%        For sockets:
%           S.comm = 'sockets'
%           S.connections = number of open connections
%           S.ipc_id = TCP/IP port number
% 

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/08 20:54:40 $

% [EOF] hdldaemon.m