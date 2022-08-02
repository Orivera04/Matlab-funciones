function ok=mbcuninstalladdon(pth, mode)
%MBCUNINSTALLADDON  Uninstall an add-on structure
%
%  OK=MBCUNINSTALLADDON(PATH)  uninstalls the add-on package
%  located in the folder PATH.  This includes removing it
%  from the path.
%

%  OK=MBCUNINSTALLADDON(PATH, MODE) allows user to control
%  whether the path is made persistent via savepath of not.
%  MODE can be -savepath or -nosave

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.4 $  $Date: 2004/04/04 03:25:50 $

ok=0;
% default behaviour is to savepath
validmodes = {'-savepath', '-nosave'};
if nargin==1
    mode = validmodes{1};
elseif ~any(strcmpi(validmodes, mode))
    error('mbc:mbcinstalladdon:InvalidArgument', 'Second input must be %s or %s', validmodes{:});
end

def_file = fullfile(pth,'mbcextras.mbc');
if exist(def_file,'file')
    try
        S=load(def_file,'-mat');
    catch
        ok=0;
        return;
    end
    if isfield(S,'MBC_EXTENSION_PACKAGE')
        if S.MBC_EXTENSION_PACKAGE
            % remove from path
            if length(S.Path)
                rm_pth=cell(size(S.Path));
                for n=1:length(S.Path)
                    rm_pth{n} = fullfile(pth, S.Path{n});
                end
                rmpath(rm_pth{:});
                if strcmpi(mode, '-savepath')
                    pathsavedOK = savepath;
                end
            end
            ok=1;
        end
    end
end
