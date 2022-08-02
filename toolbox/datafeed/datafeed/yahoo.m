function c = yahoo(url,ip,port)
%YAHOO Yahoo datafeed object constructor.
%   C = YAHOO verifies that the URL quote.yahoo.com is accessible and creates
%   a connection handle.
%
%   C = YAHOO(URL) creates the connection handle using the given URL.  For example,
%   'http://quote.yahoo.com:80'.    The difference in this URL from the default is 
%   the addition of the port number.
%
%   C = YAHOO(URL,IP,PORT) creates the connection handle using the given URL, which should 
%   be 'http://quote.yahoo.com', the IP address of the proxy server, and the port number.
%   For example, C = YAHOO('http://quote.yahoo.com','111.222.33.444',80).
%
%   See also CLOSE, FETCH, GET, ISCONNECTION.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $   $Date: 2004/04/06 01:06:13 $
