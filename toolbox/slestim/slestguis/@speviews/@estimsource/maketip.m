function str = maketip(this, datatip, info)
% MAKETIP  Build data tips for responses.
%
% INFO is a structure built dynamically by the data tip interface
% and passed to MAKETIP to facilitate construction of the tip text.

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/16 22:20:53 $

% Context 
r = info.Carrier;

% Standard tip
str1 = { sprintf('Estimation: %s', r.Name) };
str2 = maketip(info.View, datatip, info);
str  = [str1; str2];
