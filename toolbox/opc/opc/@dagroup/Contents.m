% DAGROUP Functions and Properties.
%
% DAGROUP Construction and Configuration Functions.
%   get                 - Get value of OPC Toolbox object property.
%   set                 - Set value of OPC Toolbox object property.
%   delete              - Remove OPC Toolbox objects from memory.
%   isvalid             - True for OPC Toolbox objects that are not deleted.
%
% Data Access Functions.
%   cancelasync         - Cancel asynchronous read and write operations.
%   read                - Read data synchronously from OPC groups or items.
%   readasync           - Read data asynchronously from group or items.
%   refresh             - Read all active items in a group.
%   write               - Write values to group or items.
%   writeasync          - Asynchronously write values to group or items.
%
% Logging and Buffering Functions.
%   flushdata           - Remove all logged data associated with the 
%                         dagroup object.
%   getdata             - Return logged records from OPC Toolbox engine to 
%                         MATLAB workspace.
%   peekdata            - Preview most recently acquired data.
%   start               - Start a logging task.
%   stop                - Stop a logging task.
%   wait                - Suspend MATLAB execution until object has stopped 
%                         logging.
%
% General Functions.
%   opchelp             - Return OPC Toolbox function and property help.
%   propinfo            - Return property information for OPC Toolbox 
%                         objects. 
%
% DAGROUP PROPERTIES.
% General Properties.  	
%   GroupType           - Indicates if a dagroup object is public or 
%                         private.
%   Item                - Group item array.
%   LanguageID          - Language used by the server to send text messages 
%                         to the client.
%   Name                - Descriptive name for OPC Toolbox object.
%   Parent              - OPC Toolbox object that contains the object.
%   Tag                 - Label to associate with the OPC Toolbox object. 
%   TimeBias            - Time bias of the group.
%   Type                - OPC Toolbox object type.
%   UserData            - Data you want to associate with the OPC Toolbox 
%                         object.
% 
% Callback Function and Event Properties 	
%   CancelAsyncFcn      - M-file callback function to execute when an 
%                         asynchronous operation is canceled. 
%   DataChangeFcn       - M-file callback function to execute when a data 
%                         change event occurs.
%   ReadAsyncFcn        - M-file callback function to execute when an 
%                         asynchronous read has completed. 
%   RecordsAcquiredFcn	- M-file callback function to execute when a 
%                         RecordsAcquired event is generated.
%   RecordsAcquiredFcnCount	- The number of records to acquire before a 
%                         RecordsAcquired event is generated.
%   StartFcn            - M-file callback function to execute immediately 
%                         before logging is started.
%   StopFcn             - M-file callback function to execute immediately 
%                         after logging has stopped.
%   WriteAsyncFcn       - M-file callback function to execute when an 
%                         asynchronous write has completed. 
% 
% Subscription and Logging Properties 	.
%   Active              - Group or item activation state.
%   DeadbandPercent     - Percentage change in an item value that causes a 
%                         subscription callback.
%   LogFileName         - Name of disk file to which logged data is written.
%   Logging             - Indicate whether data and events are being stored.
%   LoggingMode         - Specify where data and events are stored.
%   LogToDiskMode       - Method of disk file handling for logged data.
%   RecordsAcquired     - The number of records acquired.
%   RecordsAvailable	- The number of records available in the OPC 
%                         Toolbox engine.
%   RecordsToAcquire	- Maximum number of records for a logging session.
%   Subscription        - Enable server update when data changes.
%   UpdateRate          - Rate, in seconds, at which subscription callbacks 
%                         occur.
% 
% 
% See also OPCDA, DAITEM.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.1 $  $Date: 2004/02/09 08:39:51 $
