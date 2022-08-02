function varargout = opcguihsfn(varargin)
%OPCGUIHSFN OPCTOOL helper function for calling OPC host/server functions
%   [ErrStr,Y1,Y2,...] = OPCGUIHSFN(FunName,X1,X2,...) calls the function
%   FunName passing the arguments X1, X2 etc. to it. OPCGUIHSFN returns an
%   error string, ErrStr, and the outputs, Y1, Y2 etc. from the function
%   FunName. If FunName returns without error the ErrStr is empty. If there
%   was an error during the call to FunName, ErrStr contains the error
%   string and Y1, Y2 etc. are empty.
%
%   This function is called by OPCTOOL and should not be called directly by
%   the user.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
% $Revision: 1.1.6.3 $  $Date: 2004/03/24 20:44:52 $

try
    % Assume initially that there is no error
    varargout{1} = '';
    % Extract the node from varargin and pass it back
    varargout{2} = varargin{1};
    % Extract the function name from varargin and pass it back
    varargout{3} = varargin{2};
    % Try to call the function passed by the GUI
    [varargout{4:nargout}] = feval(varargin{2:end});
catch
    % If there is an error return the error in the first output
    varargout{1} = lasterr;
    % Return the balance of the outputs as empty
    [varargout{2:nargout}] = deal([]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function da = createclientconnect(host,serverID)
%CREATECLIENTCONNECT Create an OPC client object and connect to the server
%  DAObj = CREATECLIENTCONNECT creates an OPCDA object DAObj and connects
%  to the OPC server.

% Create the client
da = opcda(host,serverID);
% Remove all callback functions
da.ErrorFcn = [];
da.ShutdownFcn = [];
da.TimerFcn = [];
% Connect to the server
connect(da);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function deleteobj(varargin)
%DELETEOBJ Delete all OPCDA objects
%  DELETEOBJ(Obj1, Obj2, ...) deletes all OPCDA objects passed in to the
%  function.

for j = 1:nargin
    delete(varargin{j});
end
