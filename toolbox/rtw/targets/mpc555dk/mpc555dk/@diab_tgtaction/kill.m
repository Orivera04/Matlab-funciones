%
% Script to kill SingleStep
%

% Copyright 2002 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.3 $  
%   $Date: 2002/11/28 15:49:56 $
%
% function status = kill
%
function kill(obj)

% kill method for Diab compiler environment. Presumes paticular
% behaviors of 'system(<command>) environment for ps, grep, cut and
% kill commands. This method is for use in The MathWorks test
% environment to facilitate cleaning up after automatically running
% the target application.
  
[path,sdsexe,ext,ver] = fileparts(getsdsexe(obj));

[status, message] = system(['ps | grep ' sdsexe ' | cut -c1-6']);
[status, message] = system(['kill -9 ' message]);
