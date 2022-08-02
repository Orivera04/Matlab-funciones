function [mycgddnode, exportOK, msg] = export(mycgddnode, varargin)
%EXPORT  Export the contents of the data dictionary node  
%
%   mycgddnode = EXPORT(mycgddnode) prompts the user to select a file to 
%   write to the data dictionary to.   
%
%   mycgddnode = EXPORT(mycgddnode, mydictionary) exports the data dictionary
%   to the file mydictionary
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.2.2 $  $Date: 2004/02/09 08:23:17 $



% ---------------------------------------------------------------------------
% Description : Method to export the data dictionary into an XML file 
%               for import in a future session
%
% Inputs      : mycgddnode    - data dictionary node (cgddnode)
%               mydictionary  - data dictionary URL (string, optional)
% Outputs     : mycgddnode    - data dictionary node (cgddnode)
%               exportOK      - success / failure flag (0 or 1)
% ---------------------------------------------------------------------------

msg = '';

% Get data dictionary filename
if nargin <= 1
    % Select file for data dictionary using file chooser
    curdir = pwd;
    AP= mbcprefs('mbc');
    FileDefaults = getpref(AP,'PathDefaults');
    if ~isempty(FileDefaults.cagedatafiles) & exist(FileDefaults.cagedatafiles,'dir')
        cd(FileDefaults.cagedatafiles);
    end
    [filename, pathname] = uiputfile('*.xml', 'Select a location to save the Variable Dictionary');
    cd(curdir);
    if ~ischar(filename)
        exportOK = 0;
        return
    end
    mydictionary = fullfile(pathname, filename);
else
    % File specified at the command line
    mydictionary = varargin{1};
end
% check that a file extension was given
[tmppath,tmpname,extension]=fileparts(mydictionary); 
% if no extension specified add on a .xml extension
if isempty(extension)
    mydictionary=[mydictionary, '.xml'];
end

% Open the file for writing
fid = fopen(mydictionary, 'w');

% check we could open file
if(fid<0)
    msg = sprintf('Can''t open %s for writing', mydictionary);
    exportOK = 0;
    return
end

% Write the header
fprintf(fid, '%s\n', '<?xml version="1.0" encoding="UTF-8"?>');
fprintf(fid, '%s\n', '<!DOCTYPE datadictionary PUBLIC "-//MathWorks//DTD MBCDATADICTIONARY 1.0 Alpha//EN"');
fprintf(fid, '%s\n\n', '"http://www.mathworks.com/namespace/mbcdatadictionary/v1/datadictionary.dtd">');
fprintf(fid, '%s\n\n', '<datadictionary>');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ENTER YOUR ORGANISATION AND VERSION NUMBER HERE %%%%%%
%%%% DO NOT ALTER ANY OTHER PART OF THIS FILE %%%%%
thisOrganisation = 'The MathWorks';
thisCurrentVersion = 1.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(fid, '%s\n', ['<organisation>',thisOrganisation,'</organisation>']);
fprintf(fid, '%s\n\n', ['<version>',num2str(thisCurrentVersion, '%6.1f'),'</version>']);

% Separate the pointer list into vals, const, funcs
[pVals, pConsts, pFuncs] = getvalsconstfuncs(mycgddnode);

% Write the values
for n=1:length(pVals)
    valobj = pVals(n).info;
    
    fprintf(fid, '<value>\n');
    
    % Write common properties
    i_writecommonprops(fid, valobj)
    
    % Add the range and setpoint properties
    range = getrange(valobj);
    if ~isempty(range)
        fprintf(fid, '     <min>%s</min>\n', num2str(range(1)));
        fprintf(fid, '     <max>%s</max>\n', num2str(range(2)));    
    end
    setpoint = getnomvalue(valobj);
    if ~isempty(setpoint)
        fprintf(fid, '     <setpoint>%s</setpoint>\n', num2str(setpoint));
    end
    
    fprintf(fid, '</value>\n\n');
end

% Write the constants
for n=1:length(pConsts)
    constobj = pConsts(n).info;
    
    fprintf(fid, '<constant>\n');
    
    % Write common properties
    i_writecommonprops(fid, constobj)
    
    % Add the value 
    val = getnomvalue(constobj);   
    if ~isempty(range)
        fprintf(fid, '     <val>%s</val>\n', num2str(val));
    end  
    
    fprintf(fid, '</constant>\n\n');
end

% Write the symvalues
for n=1:length(pFuncs)
    symobj = pFuncs(n).info;
    
    fprintf(fid, '<symvalue>\n');
    
    % Write common properties
    i_writecommonprops(fid, symobj)
    
    % Add equation and range
    definition = getequation(symobj);
    fprintf(fid, '     <definition>%s</definition>\n', definition);  
    range = getrange(symobj);
    if ~isempty(range)
        fprintf(fid, '     <min>%s</min>\n', num2str(range(1)));
        fprintf(fid, '     <max>%s</max>\n', num2str(range(2)));    
    end
    
    fprintf(fid, '</symvalue>\n\n');
end


% Write the footer
fprintf(fid, '</datadictionary>');

%Close the file ... and report success to user
fclose(fid);
exportOK = 1;
msg = 'Variable Dictionary successfully saved.';



%--------------------------------------------------------------------------------
function [pVals, pConsts, pFuncs] = getvalsconstfuncs(dd)
%--------------------------------------------------------------------------------
pVals = [];pConsts = [];pFuncs = [];
allptrs = dd.ptrlist;
for i=1:length(allptrs)
    if issymvalue(allptrs(i).info)
        pFuncs = [pFuncs, allptrs(i)];
    elseif isconstant(allptrs(i).info)
        pConsts = [pConsts, allptrs(i)];
    else
        pVals = [pVals, allptrs(i)];
    end
end



%--------------------------------------------------------------------------------
function i_writecommonprops(fid, varobj)
%--------------------------------------------------------------------------------
% get the details
name = getname(varobj);
description = getdescription(varobj);
aliases = getaliaslist(varobj);

% write to file
fprintf(fid, '     <name>%s</name>\n', name);
if ~isempty(aliases)
    fprintf(fid, '     <alias>%s</alias>\n', aliases{:});
end
if ~isempty(description)
    fprintf(fid, '     <description>%s</description>\n', description);
end