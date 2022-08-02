function ok=mbcinstalladdon(pth, mode)
%MBCINSTALLADDON  Install an add-on structure
%
%  OK=MBCINSTALLADDON(PATH)  installs the add-on package
%  located in the folder PATH.  This includes adding it
%  to the path and executing an installation function
%  if necessary.
%

%  OK=MBCINSTALLADDON(PATH, MODE) allows user to control 
%  whether the path is made persistent via savepath of not.
%  MODE can be -savepath or -nosave

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.4 $  $Date: 2004/04/04 03:25:49 $

ok=0;
% default behaviour is to savepath
if nargin==1
    mode = '-savepath';
elseif ~(strcmpi(mode, '-savepath') || strcmpi(mode, '-nosave'))
    error('mbc:mbcinstalladdon:InvalidArgument', 'Second input must be -savepath or -nosave');
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
         % add to path
         if length(S.Path)
            add_pth=cell(size(S.Path));
            for n=1:length(S.Path)
               add_pth{n}=[pth filesep S.Path{n}];
            end
            addpath(add_pth{:});
            if strcmpi(mode, '-savepath')
                pathsavedOK = savepath;
            end
         end
         % Execute installation function if it is defined
         if ~isempty(S.InstallFcn)
            feval(S.InstallFcn);
         end     
         ok=1;
      end
   end
end
