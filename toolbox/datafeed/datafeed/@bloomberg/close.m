function close(c) 
%CLOSE Close connection to Bloomberg communications server.
%   CLOSE(C) closes the connection, C, to the Bloomberg communications server.
%
%   See also BLOOMBERG.

%   Author(s): C.F.Garvin, 02-19-99
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.6 $   $Date: 2002/04/14 16:24:16 $

%Call api disconnect function, 2 is DISCONNECT flag
bbdatafeed(2,c.connection);
