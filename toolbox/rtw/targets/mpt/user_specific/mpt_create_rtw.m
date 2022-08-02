function mpt_create_rtw(modelName,buildDir)

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $
%   $Date: 2003/09/18 18:06:09 $

% located in the special directory due to name collision issue

[sfcnsCell,buildInfo] = rtwgen(modelName, ...
    'CaseSensitivity','on',...
    'Language', 'C', ...
    'OutputDirectory',buildDir);
