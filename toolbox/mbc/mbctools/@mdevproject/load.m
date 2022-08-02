function [MP,msg]= load(MP,filename)
%LOAD
% 
%  [MP, MSG] = LOAD(MP, FILENAME)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:03:36 $

lasterr('');
msg= '';
[fok,varlist]= isProjectFile(MP,filename);

if ~fok
    msg= 'File not found or invalid format.';
    return;
end

CAN_LOAD = ~strcmp(varlist.class,'struct');

ws= warning;
warning off

if CAN_LOAD 
    % load file
    S= struct2cell(load(filename , '-mat'));
    MP= S{1};
    if isempty(MP) | ~isa(MP,'mdevproject')
        msg= lasterr;
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
    msg= 'Unknown file type';
end

warning(ws);

if isempty(msg)
    % register file 
    [MP,msg]= RegisterFile(MP,filename); 
end