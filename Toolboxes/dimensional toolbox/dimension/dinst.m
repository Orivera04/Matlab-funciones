function dinst()
% Installs the Dimensional Analysis Toolbox for Matlab
% Steffen Brueckner, 2002-02-08

disp('-----------------------------------------------');
disp('Dimensional Analysis Toolbox for Matlab');
disp('-----------------------------------------------');
disp('Copyright (c) Steffen Brueckner, 2002');
disp('http://www.sbrs.net/  datool@sbrs.net');
disp(' ');

% determine toolbox path
p = pwd;
addpath(pwd,'-end');
rehash;

disp([p ' has been added to the Matlab search path']);
disp(' ');
disp(' To add the path permanently you must start the Set Path');
disp(' utility in Matlab using the menu File -> Set Path and');
disp(' click "save" to save the current serach path');
disp(' Alternatively you can edit the file');
disp([' ' matlabroot '\toolbox\local\pathdef.m to']);
disp(' reflect the path to the dimensional analysis toolbox');
disp(' For further info please refer to the documentation');
disp(' ');

% check for standard windows directories...
if ispc
    wd = [];
    
    % try to find windows dir automatically
    if exist('C:\WINDOWS','dir') & ~exist('C:\WINNT','dir')
        wd = 'C:\WINDOWS';
    elseif ~exist('C:\WINDOWS','dir') & exist('C:\WINNT','dir')
        wd = 'C:\WINNT';
    end
    
    if isequal(wd,[])
        disp(' ');
        disp('Please enter the name your windows directory');
        disp('e.g. C:\WINDOWSor C:\WINNT');
        wd = input('WINDIR: ','s');

        if ~exist(wd,'dir')
            error('Windows directory not found!');
        end
    end
    
    % copy LiteGrid ocx and a batch file to $WINDIR\system32
    if ~exist(fullfile(p,'LiteGrid','lgrid.ocx'));
        [STATUS,MSG] = copyfile(fullfile(p,'LiteGrid','lgrid.ocx'),fullfile(wd,'system32'),'writeable');
    else
        warning('lgrid.ocx already exists. File ist not replaced.');
        MSG = [];
    end
    if MSG
        error(MSG);
        break;
    end
    [STATUS,MSG] = copyfile(fullfile(p,'LiteGrid','lgrid.bat'),fullfile(wd,'system32'),'writeable');
    if MSG
        error(MSG);
        break;
    end
    
    % run a batch file to register the ocx
    [STATUS,MSG] = dos(fullfile(wd,'system32','lgrid.bat'));
    
    % everything seems to be fine
    % delete unnecessary file versions
    delete(fullfile(wd,'system32','lgrid.bat'));
    %delete(fullfile(p,'LiteGrid','lgrid.bat'));
    %delete(fullfile(p,'LiteGrid','lgrid.ocx'));
    %delete(fullfile(p,'dinst.m'));                   % delete myself
    
    disp('LiteGrid ActiveX control registered.');
else
    disp('LiteGrid ActiveX control can only be installed using');
    disp('a Windows operating system');
end