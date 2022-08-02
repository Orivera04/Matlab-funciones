function x = isconnection(c) 
%ISCONNECTION True if valid Hyperfeed connection.
%   X = ISCONNECTION(C) returns 1 if C is a valid Hyperfeed connection
%   and 0 otherwise.
%
%   See also HYPERFEED, CLOSE, FETCH, GET.

%   Author(s): C.F.Garvin, 04-07-99
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.3 $   $Date: 2002/04/14 16:23:14 $

%If method is called, it's with Hyperfeed object, so it is always valid.
x = 1;
