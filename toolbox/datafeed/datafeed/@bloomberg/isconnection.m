function x = isconnection(c) 
%ISCONNECTION True if valid Bloomberg connection.
%   X = ISCONNECTION(C) returns 1 if C is a valid Bloomberg connection
%   and 0 otherwise.
%
%   See also BLOOMBERG, CLOSE, FETCH, GET.

%   Author(s): C.F.Garvin, 04-07-99
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/04/14 16:24:28 $

%VALIDCONNECTION flag is 5 for call to bbdatafeed
bbflag = 5;

%Validate connection
x = bbdatafeed(bbflag,c.connection);
