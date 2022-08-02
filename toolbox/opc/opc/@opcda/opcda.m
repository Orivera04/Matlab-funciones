function obj = opcda(varargin)
%OPCDA Construct an OPC data access client object.
%   Obj = OPCDA('Host','ServerID') constructs an OPC data access object,
%   Obj, for the host specified by Host and the OPC server ID specified by
%   ServerID. When you construct Obj, its Status property is initially set
%   to disconnected. To communicate with the server, you must connect Obj
%   to the server with the CONNECT function.
%
%   Obj = OPCDA ('Host','ServerID','P1',V1,'P2',V2,...) constructs an OPC
%   data access object, Obj, with the specified property names set to the
%   respective property value. If an invalid property name or property
%   value is specified,  the object will not be created.
%
%   Note that the property value pairs can be in any format supported by
%   the SET function, i.e., param-value string pairs, structures, and
%   param-value cell array pairs.
%
%   At any time, you can view a complete listing of OPC Toolbox functions
%   and properties with the OPCHELP function.
%
%   See also OPCDA/CONNECT, OPCHELP, OPCDA/SET.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.8 $  $Date: 2004/03/24 20:43:14 $

% Parse Input Arguments.
% Syntax checking is performed later. For now, just extract
% the inputs into our own variables.
PVpairs = {};
switch(nargin),
case 0,
    rethrow(mkerrstruct('opc:opcda:inputsnotenough'));
case 1,
    if strcmp(class(varargin{1}), 'opcda')
        % Return the object as is.
        obj = varargin{1};
    elseif (isa(varargin{1}, 'handle') || ... % used by opcfind to wrap udd obejcts
            strcmp(class(varargin{1}), 'struct')) % used by loadobj to reconstruct objects
        obj = struct;
        obj = class(obj, 'opcda',opcroot(varargin{1}));
        % Assumption: We don't need to reset parents.
    else     
        rethrow(mkerrstruct('opc:opcda:syntaxerror'));
    end
otherwise
    host = varargin{1};
    serverid = varargin{2};
    if ~strcmp(class(host),'char') 
         rethrow(mkerrstruct('opc:opcda:hostarg'));
    end
    if ~strcmp(class(serverid),'char') 
         rethrow(mkerrstruct('opc:opcda:serveridarg'));
    end
    if nargin>=3
        PVpairs = varargin(3:end); 
    end
    obj = struct;
    obj = class(obj, 'opcda',opcroot(opcmex('opcda',host,serverid)));
    % Set my oops representation
    udsetoops(getudd(obj), obj);
end

% Assign the properties.
if ~isempty(PVpairs)
   try      
      set(obj, PVpairs{:});
   catch
      delete(obj); 
      rethrow(mkerrstruct(lasterror));
   end
end
