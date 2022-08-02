function cgbstart(file)
%CGBSTART Start an initialised CAGE Browser session
%
%  CGBSTART starts up the cage browser.
%  CGBSTART(FILE) starts up the browser and loads FILE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/02/09 08:39:22 $

loaddefault = true;
addtolist = false;

if nargin
    [p,f] = fileparts(file);
    if isempty(p)
        file = which(file);  % retrieve full pathname
    end
    if isempty(file)
        warning('mbc:cgbstart:FileNotFound', 'Can''t find file %s.', f );
    else
        %Load a file
        prj = cgproject;
        [prj,msg] = load(prj,file,1,1);
        if ~isempty(msg) || isempty(prj) % error, or empty project
            if ~isempty(prj)
                freeptr(address(prj));
            end
            if ~isempty( msg )
                warning('mbc:cgbstart:FileLoadProblem', ...
                    'Problem loading file %s: %s', file, msg );
            else
                warning('mbc:cgbstart:FileLoadProblem', ...
                    'Problem loading file %s.', file);
            end
        else
            if strcmp(projectfile(prj),file)
                % If we have a filename and it wasn't changed by the load procedure,
                % we will add it to the recently-used file list.
                addtolist = true;
            end
            loaddefault = false;
        end
    end
end

if loaddefault
    % No file loaded.  Load up a new one called "Untitled"
    AP = mbcprefs('mbc');
    pth = getpref(AP,'PathDefaults');
    file = fullfile(pth.cagfiles,'Untitled');
    prj = info(cgcreateproject(file));
    prj = setmodified(prj,1);
end

cgb = cgbrowser;
cgb.show(address(prj));

if addtolist
    % this has to be done last
    cgb.addToFileList(prj);
end
