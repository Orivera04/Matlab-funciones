function [PROJ,msg]= load(PROJ,filename,allowrename,promptrename);
%LOAD
%
%  [P,MSG]=load(P,FILE)
%  [P,MSG]=load(P,FILE,ALLOWRENAME)
%  [P,MSG]=load(P,FILE,ALLOWRENAME,PROMPTRENAME)
%
%  If the (optional) ALLOWRENAME flag is supplied and is non-zero, the 
%  load procedure will rename and load a file if it is already open.
%  If the (optional) PROMPTRENAME flag is supplied and is non-zero, the user will
%  be prompted before a file is renamed, and given the option to cancel.
%
%  P is the loaded project.
%  MSG is an error message if there was a problem.  If there was
%  a problem, but the user has already been informed, MSG will be empty
%  but so will P.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.2.3 $  $Date: 2004/02/09 08:28:21 $

msg= '';
% find what sort of variable this file contains
if exist(filename)~=2
    msg= 'File not found';
    return;
end

try
    varlist= whos('-file',filename);
    if length(varlist)==1
        CAN_LOAD = ~strcmp(varlist.class,'struct');
    else
        msg = 'Unable to load files that were created before version 1.0';
        return
    end
catch
    % unable to read - not a mat-file?
    msg= 'Invalid file format';
    return;
end

if CAN_LOAD
    % load file
    S= struct2cell(load(filename , '-mat'));
    
    PROJ= S{1};
    if isempty(PROJ) | ~isa(PROJ,'cgproject')
        msg=lasterr;
        if ~isempty(msg)
            s= findstr(msg,sprintf('\n'));
            if ~isempty(s)
                msg= msg(s(1)+1:end);
            end
        else
            msg= 'Invalid or corrupt file';
        end
    end
else
    msg= 'Invalid file format';
    return
end

if isempty(msg)
    if isfileopen(PROJ,filename)
        if nargin>=3 & allowrename
            if nargin>=4 & promptrename
                answer=questdlg(['This file is already in use.  Do you '...
                                 'want to open it anyway? (Your copy of '...
                                 'the file will be given a new name)'],...
                                'File Already Open','Yes','No','Yes');
                if strcmp(answer,'No')
                    deleteproject(PROJ);
                    PROJ = [];
                    return;
                end
            end
            % look for new name
            [pth,file,ext]= fileparts(filename);
            
            if strcmp(file(end),')')
                ind=findstr(file,'(');
                n= sscanf(file(ind(end):end),'(%d)');
                if isempty(n)
                    n=1;
                    root=file;
                else
                    root=file(1:ind(end)-1);
                end
            else
                n=1;
                root=file;
            end
            while exist(fullfile(pth,[root sprintf('(%d)',n) ext]),'file') | ...
                    exist(fullfile(pth,['~' root sprintf('(%d)',n) '.tmp']),'file')
                n=n+1;
            end
            filename=fullfile(pth,[root sprintf('(%d)',n) ext]);
        else
            msg='File already open';
            deleteproject(PROJ);
            return
        end
    end
    % register file 
    [PROJ,msg]= registerfile(PROJ,filename); 
end
