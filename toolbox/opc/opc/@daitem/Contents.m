% DAITEM Functions and Properties.
%
% DAITEM Construction and Configuration Functions.
%   get                 - Get value of OPC Toolbox object property.
%   set                 - Set value of OPC Toolbox object property.
%   delete              - Remove OPC Toolbox objects from memory.
%   isvalid             - True for OPC Toolbox objects that are not deleted.
%
% Data Access Functions.
%   read                - Read data synchronously from OPC groups or items.
%   readasync           - Read data asynchronously from group or items.
%   write               - Write values to group or items.
%   writeasync          - Asynchronously write values to group or items.
%
% General Functions.
%   opchelp             - Return OPC Toolbox function and property help.
%   propinfo            - Return property information for OPC Toolbox 
%                         objects. 
%
% DAITEM PROPERTIES.
% General Properties.
%   AccessRights        - Inherent nature of access to item.
%   Active              - Group or item activation state.
%   ItemID              - Fully qualified ID on the OPC server.
%   Parent              - OPC Toolbox object that contains the object.
%   ScanRate            - Fastest possible data update rate.
%   Tag                 - Label to associate with the OPC Toolbox object. 
%   Type                - OPC Toolbox object type.
%   UserData            - Data you want to associate with the OPC Toolbox 
%                         object.
% 
% Data Properties.
%   CanonicalDataType   - Server’s data type for the item.
%   DataType            - Client item’s data type.
%   Quality             - Quality of the data value.
%   TimeStamp           - Time the item was last read.
%   Value               - Item value.
% 
% 
% See also OPCDA, DAGROUP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.1 $  $Date: 2004/02/09 08:39:55 $
