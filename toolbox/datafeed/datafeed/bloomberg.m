function c = bloomberg(p,i)
%BLOOMBERG Bloomberg communications server connection.
%   C = BLOOMBERG(P,I) establishes a connection to the Bloomberg communications
%   server using the port number, P, and the IP Address, I.
%
%   C = BLOOMBERG makes a connection using the default port number 8194 to the 
%   local Bloomberg communications server.
%
%   C = BLOOMBERG(P) establishes a connection on the local machine using port 
%   number P to the local Bloomberg communications server.
%
%   C = BLOOMBERG(8194,'111.222.33.444') makes a connection to the Bloomberg
%   communications server on port 8194 of the machine with IP Address 111.222.33.44.
%
%   See also CLOSE, FETCH, GET, ISCONNECTION.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $   $Date: 2004/04/06 01:06:10 $


