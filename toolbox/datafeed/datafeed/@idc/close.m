function close(c)
%CLOSE Close connection to IDC data server.
%   CLOSE(C) closes the connection, C, to the IDC data server.
%
%   See also IDC.

%   Author(s): C.F.Garvin, 12-08-99
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.5 $   $Date: 2002/04/14 16:23:49 $

%Call idcdatafeed disconnect function, 2 is DISCONNECT flag
idcdatafeed(1,2);
