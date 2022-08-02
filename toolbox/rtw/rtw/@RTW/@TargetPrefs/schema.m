function schema
%SCHEMA  Class definition function (for RTW.targetprefs).

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/19 01:16:43 $


%%%% Get handles of associated packages and classes
% Not derived from any other class
hCreateInPackage   = findpackage('RTW');

%%%% Construct class
hThisClass = schema.class(hCreateInPackage, 'TargetPrefs');

%%%% Declare static method
hThisMethod = schema.method(hThisClass, 'load', 'static');
%%%% Add properties to this class
