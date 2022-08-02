function status = add_mpm_path(varargin)
%ADD_MPM_PATH Add the mpm directories to the path

%   Donn Shull
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $
%   $Date: 2004/04/15 00:29:19 $

addpath([matlabroot, filesep, 'toolbox', filesep, 'rtw', filesep, 'targets', filesep, 'mpt', filesep, 'user_specific']);
addpath([matlabroot, filesep, 'toolbox', filesep, 'rtw', filesep, 'targets', filesep, 'mpt', filesep, 'mpt']);
addpath([matlabroot, filesep, 'toolbox', filesep, 'rtw', filesep, 'targets', filesep, 'mpt']);
status = savepath;
rehash toolboxreset;
rehash toolboxcache;
if nargin > 0
    if varargin{1}== 0
        exit;
    end
end
