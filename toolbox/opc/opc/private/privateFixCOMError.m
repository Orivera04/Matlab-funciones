function err = privateFixCOMError(id)
%privateFixCOMError Replace COM error messages

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.5 $  $Date: 2004/02/01 22:07:12 $

switch lasterr
    case 'The RPC server is unavailable.'
        err.message = 'Unknown host';
        err.identifier = id;
    otherwise
        err = lasterror;
end