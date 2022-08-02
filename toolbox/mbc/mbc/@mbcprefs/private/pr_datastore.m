function varargout = pr_datastore(action,varargin)
%PR_DATASTORE Private persistent data for prefs
%
%  OUT=PR_DATASTORE(ACTION,IN) executes ACTION on the datastore
%  using any inputs IN and returns outputs OUT.
%
%  Various I/O syntax are allowed:
%
%   prefname :- String,    Name of preference
%   data     :- Variant,   Data to store/retrieve
%   flg      :- Boolean,   Normally a success indicator
%   featname :- String,    Name of feature
%   name     :- String,    Name of preference set
%
%   flg = PR_DATASTORE('init',[prefset])
%   PR_DATASTORE('clear')
%   flg = PR_DATASTORE('save')
%   flg = PR_DATASTORE('merge',filename,{'pref'/'feat'}{prefname/featname});
%
%   data = PR_DATASTORE('getpref',prefname)
%   flg = PR_DATASTORE('setpref',prefname,data)
%   flg = PR_DATASTORE('ispref',prefname)
%   flg = PR_DATASTORE('addpref',prefname)
%   flg = PR_DATASTORE('rempref',prefname)
%         PR_DATASTORE('listpref')
%
%   data = PR_DATASTORE('getfeat',featname)
%   flg = PR_DATASTORE('setfeat',featname,data)
%   flg = PR_DATASTORE('isfeat',featname)
%   flg = PR_DATASTORE('addfeat',featname)
%   flg = PR_DATASTORE('remfeat',featname)
%         PR_DATASTORE('listfeat')
%
%   name = PR_DATASTORE('getprefsetname')
%   flg = PR_DATASTORE('setprefsetname',name)
%   flg = PR_DATASTORE('addprefset',name)
%   flg = PR_DATASTORE('remprefset')
%   flg = PR_DATASTORE('changeprefset',name)
%   flg = PR_DATASTORE('isprefset',name)
%   PR_DATASTORE('lockset',flg)
%
%   PR_DATASTORE('reset')
%   PR_DATASTORE('switchtolocal',bool);
%
%   data=PR_DATASTORE('setsinfo');
%   data=PR_DATASTORE('prefsinfo');
%   data=PR_DATASTORE('featsinfo');

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.3 $  $Date: 2004/04/04 03:25:38 $

if ~nargin
    return
end

mlock

persistent Prefs
persistent Feats
persistent DataLoaded
persistent PrefSet
persistent SETLOCK
persistent USE_CLASS_SETS

if isempty(DataLoaded)
    i_checkpersonalprefs;
    DataLoaded=0;
    PrefSet = 'Default';
    SETLOCK=0;
    USE_CLASS_SETS=0;
end

action=lower(action);
switch action
    case 'init'
        if nargin<2
            openprefs = PrefSet;
        else
            openprefs = varargin{1};
        end
        if SETLOCK && ~strcmp(PrefSet,openprefs)
            warning('The current Preference set has been locked and cannot be changed');
            openprefs=PrefSet;
        end
        if ~DataLoaded || ~strcmp(PrefSet,openprefs)
            ok=i_savetofile(PrefSet,Prefs,Feats);
            if ~ok && DataLoaded
                warning('Failed to save current Preference Set');
            end
            PrefSet = openprefs;
            [Prefs,Feats,DataLoaded] = i_loadfromfile(PrefSet);
            varargout{1} = DataLoaded;   % return loaded flag as a success indicator
        else
            % already loaded in - return success
            varargout{1} = 1;
        end

    case 'unlock'
        % undocumented feature, to aid debugging
        munlock
    case 'reset'
        munlock
        clear Prefs Feats DataLoaded PrefSet SETLOCK USE_CLASS_SETS
    case 'switchtolocal'
        USE_CLASS_SETS=varargin{1};
    case 'switchtolocalsetting'
        varargout{1}=USE_CLASS_SETS;

    otherwise
        % before doing any other op, check the Data is initialised
        if ~DataLoaded
            % error out
            error('Prefs object is not initialised!');
        end

        switch action
            case 'clear'
                % clear all data from set
                Prefs.names={};
                Prefs.data={};
                Feats.names={};
                Feats.flags=false(0);
            case 'save'
                varargout{1} = i_savetofile(PrefSet,Prefs,Feats);

            case 'merge'
                % open a new prefs file into temp variables and merge in new preferences.
                fnm=varargin{1};
                tp=varargin{2};
                prefnm=varargin{3};

                tmpVars = load(fnm);
                % decide if its a new one or an update
                if strcmpi(tp,'pref')
                    nms=Prefs.names;
                    tmpVars=tmpVars.Prefs;
                    act=1;
                else
                    nms=Feats.names;
                    tmpVars=tmpVars.Feats;
                    act=0;
                end

                newone=strmatch(prefnm,nms,'exact');
                ind=strmatch(prefnm,tmpVars.names);
                if ~isempty(newone);
                    % update
                    if act
                        pr_datastore('setpref',prefnm,tmpVars.data{ind});
                    else
                        pr_datastore('setfeat',prefnm,tmpVars.flags{ind});
                    end
                else
                    % new one
                    if act
                        pr_datastore('addpref',prefnm);
                        pr_datastore('setpref',prefnm,tmpVars.data{ind});
                    else
                        pr_datastore('addfeat',prefnm);
                        pr_datastore('setfeat',prefnm,tmpVars.flags{ind});
                    end
                end


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% Preferences interface
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            case 'getpref'
                % expect name as varargin, return data
                i=strmatch(varargin{1},Prefs.names,'exact');
                if ~isempty(i)
                    varargout(1) = Prefs.data(i);
                else
                    error(['FPreference "' varargin{1} '" not found']);
                end

            case 'setpref'
                % expect name and data as args
                i=strmatch(varargin{1},Prefs.names,'exact');
                if ~isempty(i)
                    Prefs.data(i)=varargin(2);
                    varargout{1}=1;
                else
                    varargout{1}=0;
                end

            case 'ispref'
                i=strmatch(varargin{1},Prefs.names,'exact');
                if isempty(i)
                    varargout{1}=0;
                else
                    varargout{1}=1;
                end
            case 'addpref'
                % check it doesn't already exist
                i=strmatch(varargin{1},Prefs.names,'exact');
                if isempty(i)
                    % add it
                    Prefs.names(end+1)=varargin(1);
                    Prefs.data(end+1)={[]};
                    varargout{1}=1;
                else
                    varargout{1}=0;
                end

            case 'rempref'
                i=strmatch(varargin{1},Prefs.names,'exact');
                if ~isempty(i)
                    Prefs.names(i)=[];
                    Prefs.data(i)=[];
                    varargout{1}=1;
                else
                    varargout{1}=0;
                end

            case 'listpref'
                fprintf(1,'\nCurrent defined preferences:\n');
                for n=1:length(Prefs.names)
                    fprintf(1,['    ' Prefs.names{n} '\n']);
                end
                fprintf(1,'\n');

            case 'prefsinfo'
                varargout{1}=Prefs.names;



                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% Features interface
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            case 'addfeat'
                % check it doesn't already exist
                i=strmatch(varargin{1},Feats.names,'exact');
                if isempty(i)
                    % add it
                    Feats.names(end+1)=varargin(1);
                    Feats.flags(end+1)=false;
                    varargout{1}=1;
                else
                    varargout{1}=0;
                end
            case 'remfeat'
                i=strmatch(varargin{1},Feats.names,'exact');
                if ~isempty(i)
                    Feats.names(i)=[];
                    Feats.flags(i)=[];
                    varargout{1}=1;
                else
                    varargout{1}=0;
                end
            case 'isfeat'
                i=strmatch(varargin{1},Feats.names,'exact');
                if isempty(i)
                    varargout{1}=0;
                else
                    varargout{1}=1;
                end
            case 'getfeat'
                i=strmatch(varargin{1},Feats.names,'exact');
                % get feature
                if ~isempty(i)
                    varargout{1} = Feats.flags(i);
                else
                    % nothing to return; error instead
                    error(['Feature "' varargin{1} '" not found']);
                end
            case 'setfeat'
                i=strmatch(varargin{1},Feats.names,'exact');
                % set feature
                if ~isempty(i)
                    Feats.flags(i)=(varargin{2}~=0);    % converts to 0/1
                    varargout{1}=1;
                else
                    varargout{1}=0;
                end

            case 'listfeat'
                fprintf(1,'\nCurrent defined features:\n');
                for n=1:length(Feats.names)
                    fprintf(1,['    ' Feats.names{n} '\n']);
                end
                fprintf(1,'\n');

            case 'featsinfo'
                varargout{1}=Feats.names;


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% Preference Set Management
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            case 'getprefsetname'
                varargout{1}=PrefSet;
            case 'setprefsetname'
                if ~SETLOCK
                    if ischar(varargin{1})
                        % change name of current set
                        i=strmatch(PrefSet,PrefNames(:,1));
                        PrefNames(i,1) = varargin(1);
                        PrefNames(i,2) = {['Prefs_' varargin{1} '.mat']};
                        try
                            pth=i_prefdir;

                            % rename preferences file
                            % copy and delete old one
                            [ok,msg]=copyfile(fullfile(pth,PrefSet),fullfile(pth,PrefNames{i,2}));
                            if ~ok
                                error(msg)
                            end
                            delete(fullfile(pth,PrefSet));

                            % save new PrefNames table
                            save(fullfile(pth,'mbcprefsets.mat'),'PrefNames');

                            PrefSet = varargin{1};
                            varargout{1} = 1;
                        catch
                            varargout{1} = 0;
                        end
                    end
                else
                    varargout{1}=0;
                    warning('The current Preference set has been locked.  The name cannot be altered');
                end
            case 'addprefset'
                % add new entries to name/filename table and create new file
                % do this in a subfunction to isolate current data from new ones
                varargout{1} = i_createnewfile(varargin{:});

            case 'remprefset'
                % Removing last set => need to reinit a new one
                % load PrefSet table
                pth=i_prefdir;

                load(fullfile(pth,'mbcprefsets.mat'));
                i=strmatch(PrefSet,PrefNames(:,1),'exact');

                % remove file
                try
                    delete(fullfile(pth,varargin{1}));
                    PrefNames(i,:)=[];
                    save(fullfile(pth,'mbcprefsets.mat'),'PrefNames');

                    if ~isempty(PrefNames)
                        % switch to first on list
                        PrefSet = PrefNames{1,1};
                    else
                        % intialise a new one called Default
                        ok=i_createnewfile('Default');
                        if ok
                            PrefSet='Default';
                        else
                            error('Error removing Preference Set');
                        end
                    end
                    [Prefs,Feats,DataLoaded] = i_loadfromfile(PrefSet);
                catch
                    varargout{1}=0;
                end

            case 'changeprefset'
                % reinit with a new set - should we auto-save??  I think so
                if ~SETLOCK
                    ok=i_savetofile(PrefSet, Prefs, Feats);
                    PrefSet = varargin{1};
                    [Prefs,Feats,DataLoaded] = i_loadfromfile(PrefSet);
                    varargout{1} = DataLoaded;   % return loaded flag as a success indicator
                else
                    varargout{1}=0;
                    warning('The current Preference set has been locked and cannot be changed');
                end
            case 'isprefset'
                pth=i_prefdir;
                load(fullfile(pth,'mbcprefsets.mat'));
                i=strmatch(varargin{1},PrefNames(:,1),'exact');
                if isempty(i)
                    varargout{1}=0;
                else
                    varargout{1}=1;
                end
            case 'setsinfo'
                load('mbcprefsets.mat');
                varargout{1}=PrefNames(:,1);
            case 'lockset'
                % set a locking flag which prevents set from being changed
                if varargin{1}
                    SETLOCK=1;
                else
                    SETLOCK=0;
                end
        end
end
return







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Useful subfunctions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [Prefs, Feats, DataLoaded]=i_loadfromfile(Set)
% Set is a string indicating a name for the preference set to be used.

DoInitialisation = ~pr_datastore('switchtolocalsetting');
% load in the current known sets
pth=i_prefdir;

load(fullfile(pth,'mbcprefsets.mat'));

% find name of preference file
i=strmatch(Set,PrefNames(:,1),'exact');
fnm = PrefNames{i,2};

try
    load(fullfile(pth,fnm));
    DataLoaded=1;
    % initialise properties if this is the first time the set has been loaded
    if DoInitialisation && ~Initialised.Done
        % execute initialisation command
        if ~isempty(Initialised.Command)
            [Prefs, Feats] = feval(Initialised.Command,Prefs,Feats);
        end
        % save initialised data
        Initialised.Done = true;
        save(fullfile(pth,fnm),'Prefs','Feats','Initialised');
    end
catch
    % preference file doesn't exist
    Prefs=[];
    Feats=[];

    % update our list of preference sets
    PrefNames(i,:)=[];
    mnm=fullfile(pth,'mbcprefsets.mat');
    save(mnm,'PrefNames');
    DataLoaded=0;
end
return





function ok=i_savetofile(Set, Prefs, Feats)
% Set is the preference set to save to
% load in the current known sets
pth=i_prefdir;
PrefNames = {};
load(fullfile(pth,'mbcprefsets.mat'));

% find name of preference file
i=strmatch(Set,PrefNames(:,1),'exact');
fnm = PrefNames{i,2};

mnm=fullfile(pth,fnm);
try
    save(mnm,'Prefs','Feats','-append');   % -append flag prevents Initialised variable being overwritten
    ok=1;
catch
    ok=0;
end
return




function ok=i_createnewfile(Set,InitCmd)

if nargin <2
    InitCmd = '';
end
try
    % create new file
    Feats.names={};
    Feats.flags=[];
    Prefs.names={};
    Prefs.data={};
    Initialised.Done = false;
    Initialised.Command = InitCmd;

    pth=i_prefdir;
    save(fullfile(pth,['Prefs_' Set '.mat']),'Prefs','Feats','Initialised');

    % add set to table
    load(fullfile(pth,'mbcprefsets.mat'));
    PrefNames(end+1,1) = {Set};
    PrefNames(end,2) = {['Prefs_' Set '.mat']};
    save(fullfile(pth,'mbcprefsets.mat'),'PrefNames');
    ok=1;
catch
    ok=0;
end

return






function i_checkpersonalprefs
% check that MATLAB prefdir exists!
pdir=prefdir;
if ~exist(pdir,'dir');
    i_recursivedirmake(pdir);
end

% check that the personal prefs dir has been created - if not then create it
mbcprefdir=[pdir filesep 'MBC' mbcver];
defpth=fileparts(mfilename('fullpath'));
ok=exist(mbcprefdir, 'dir');
if ~ok
    % create dir and copy standard files to location
    [status msg]= mkdir(pdir, ['MBC' mbcver]);
    if status
        i_copysets(defpth, mbcprefdir);
    else
        error(msg);
    end
else
    % check that the userpreference files all exist
    if exist(fullfile(mbcprefdir,'mbcprefsets.mat'),'file')

        defprefs=load('mbcprefsets.mat');
        userprefs=load(fullfile(mbcprefdir,'mbcprefsets.mat'));
        todel=[];
        for k=1:size(userprefs.PrefNames,1)
            if ~exist(fullfile(mbcprefdir,userprefs.PrefNames{k,2}),'file')
                defloc=strcmp(userprefs.PrefNames{k,2},defprefs.PrefNames(:,2));
                if ~isempty(defloc)
                    fid=fopen(fullfile(defpth,defprefs.PrefNames{defloc,2}),'r');
                    fl=fread(fid,inf,'uint8=>uint8');  fclose(fid);
                    fid=fopen(fullfile(mbcprefdir,defprefs.PrefNames{defloc,2}),'w');
                    fwrite(fid,fl,'uint8');  fclose(fid);
                else
                    % cannot locate a version of the preference file: delete entry from PrefNames
                    todel=[todel k];
                end
            end
        end
        if ~isempty(todel)
            PrefNames=userprefs.PrefNames;
            PrefNames(todel,:)=[];
            save(fullfile(mbcprefdir,'mbcprefsets.mat'),'PrefNames');
        end
    else
        i_copysets(defpth, mbcprefdir);
    end
end
return


function i_recursivedirmake(D)

[A,B]=fileparts(D);
% make sure A exists
if ~exist(A,'dir')
    i_recursivedirmake(A);
end
% make B in A
mkdir(A,B);




function i_copysets(defpth,mbcprefdir)
fid=fopen(fullfile(defpth,'mbcprefsets.mat'),'r');
fl=fread(fid,inf,'uint8=>uint8');  fclose(fid);
fid=fopen(fullfile(mbcprefdir,'mbcprefsets.mat'),'w');
fwrite(fid,fl,'uint8');  fclose(fid);

defprefs=load('mbcprefsets.mat');
% save each known preference set across
for k=1:size(defprefs.PrefNames,1)
    fid=fopen(fullfile(defpth,defprefs.PrefNames{k,2}),'r');
    fl=fread(fid,inf,'uint8=>uint8');  fclose(fid);
    fid=fopen(fullfile(mbcprefdir,defprefs.PrefNames{k,2}),'w');
    fwrite(fid,fl,'uint8');  fclose(fid);
end



function d=i_prefdir
USE_CLASS_SETS=pr_datastore('switchtolocalsetting');
if USE_CLASS_SETS
    d=fileparts(mfilename('fullpath'));
else
    d=fullfile(prefdir,['MBC',mbcver]);
end
return


