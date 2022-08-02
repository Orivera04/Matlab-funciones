function varargout = opcguiaidlgfn(varargin)
%OPCGUIAIDLGFN OPCTOOL helper function for calling OPC AddItemDlg functions
%   [ErrStr,Y1,Y2,...] = OPCGUIAIDLGFN(FunName,X1,X2,...) calls the function
%   FunName passing the arguments X1, X2 etc. to it. OPCGUIACDLGFN returns an
%   error string, ErrStr, and the outputs, Y1, Y2 etc. from the function
%   FunName. If FunName returns without error the ErrStr is empty. If there
%   was an error during the call to FunName, ErrStr contains the error
%   string and Y1, Y2 etc. are empty.
%
%   This function is called by OPCTOOL and should not be called directly by
%   the user.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
% $Revision: 1.1.6.3 $  $Date: 2004/03/24 20:44:49 $

try
    % Assume initially that there is no error
    varargout{1} = '';
    % Try to call the function passed by the GUI
    [varargout{2:nargout}] = feval(varargin{:});
catch
    % If there is an error return the error in the first output
    varargout{1} = lasterr;
    % Return the balance of the outputs as empty
    [varargout{2:nargout}] = deal([]);
end
