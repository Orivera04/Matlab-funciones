function status = remove_mpm_path(varargin)
%REMOVE_MPM_PATH Removes the mpm directories from the path

%   Donn Shull
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.1.4.3 $
%   $Date: 2004/04/15 00:29:34 $

rmpath([matlabroot, filesep, 'toolbox', filesep, 'rtw', filesep, 'targets', filesep, 'mpt']);
rmpath([matlabroot, filesep, 'toolbox', filesep, 'rtw', filesep, 'targets', filesep, 'mpt', filesep, 'mpt']);
rmpath([matlabroot, filesep, 'toolbox', filesep, 'rtw', filesep, 'targets', filesep, 'mpt', filesep, 'user_specific']);
status = savepath;
if nargin > 0
    if varargin{1}== 0
        exit
    end
end
