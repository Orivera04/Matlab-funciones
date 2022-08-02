function MBstart(file)
%MBSTART Start an initialised MBrowser session
%
%  MBSTART starts up the model browser.
%  MBSTART(FILE) starts up the browser and loads FILE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.4 $  $Date: 2004/02/09 08:20:39 $

addtolist = false;
loaddefault = true;

if nargin
    % Try to load a file
    [p,f] = fileparts(file);
    if isempty(p)
        file = which(file);  % retrieve full pathname
    end
    if isempty(file)
        warning('mbc:mbstart:FileNotFound', 'Can''t find file %s.', f );
    else
        MP = mdevproject;
        [MP,msg] = load(MP,file);
        if ~isempty( msg ) || isempty(MP)
            if ~isempty(MP)
                freeptr(address(MP));
            end
            if ~isempty(msg)
                warning('mbc:mbstart:FileLoadProblem', ...
                    'Problem loading file %s: %s', file, msg );
            else
                warning('mbc:mbstart:FileLoadProblem', ...
                    'Problem loading file %s.', file);
            end
        else
            loaddefault = false;
            addtolist = true;
        end
    end
end

if loaddefault
    Pathname = xregGetDefaultDir('Projects');
    Filename = 'Untitled';
    fname = fullfile(Pathname,Filename);
    MP = mdevproject(fname,[],[]);
end

mbH = MBrowser;
mbH.Show(address(MP));

if addtolist
    mbH.addToFileList(MP);
end