function utype_establish
%UTYPE_ESTABLISH  Initialize the user data types database global.
%
%   UTYPE_ESTABLISH
%         Sets the global variable userTypes and initializes it to empty.

%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.7.4.3 $
%   $Date: 2004/04/15 00:29:13 $


userTypes = '';
rtwprivate('rtwattic', 'AtticData', 'userTypes',userTypes);
