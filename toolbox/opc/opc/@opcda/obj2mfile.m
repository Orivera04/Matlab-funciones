function obj2mfile(objects, filename, varargin)
%OBJ2MFILE Convert OPC Toolbox object to MATLAB code.
%   OBJ2MFILE(Obj,'FileName') converts the opcda object Obj to the
%   equivalent MATLAB code using the SET syntax and saves the MATLAB code
%   to a file specified by FileName. If an extension is not specified, the
%   .m extension is used. Only those properties that are not set to their
%   default values are written to FileName.
%
%   OBJ2MFILE(Obj,'FileName','Syntax') converts the OPC Toolbox object to
%   the equivalent MATLAB code using the specified Syntax and saves the
%   code to the file, FileName. Syntax can be either 'set' or 'dot'. By
%   default, the 'set' Syntax is used.
%
%   OBJ2MFILE(Obj,'FileName','Mode') and
%   OBJ2MFILE(Obj,'FileName','Syntax','Mode') saves the equivalent MATLAB
%   code for all properties if Mode is 'all' and saves only the properties
%   that are not set to their default values if Mode is 'modified'. By
%   default, the 'modified' Mode is used.
%
%   If Obj's UserData is not empty or if any of the callback properties
%   are set to a cell array of values or to a function handle, then the
%   data stored in those properties is written to a MAT-file when the OPC
%   Toolbox object is converted and saved. The MAT-file has the same name
%   as the M-file containing the OPC Toolbox object code.
%
%   The values of read-only properties will not be restored. For example,
%   if an object is saved with a Status property value of 'connected', the
%   object will be recreated with a Status property value of
%   'disconnected' (the default value). You can use PROPINFO to determine
%   if a property is read-only.
%
%   To recreate Obj, type the name of the M-file.
%
%   Examples
%       da = opcda('localhost','Dummy.Server');
%       set(da, 'Tag', 'myopcTag','Timeout',300);
%       grp = addgroup(da, 'TestGroup');
%       itm = additem(grp, 'Dummy.Tag1');
%       obj2mfile(da, 'myopc.m','dot','all');
%       copyOfDA = myopc;
%
%   See also OPCROOT/PROPINFO, OPCHELP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.7 $  $Date: 2004/03/24 20:43:13 $

% Argument checking
% Number of args
errorMsg = nargchk(2, 4, nargin);
if ~isempty(errorMsg),
    rethrow(mkerrstruct('opc:obj2mfile:inargs', errorMsg));
end
% Check that first arg is the OPCDA object since the method could be called
% with obj2mfile('me', obj);
if ~isa(objects, 'opcda'),
    rethrow(mkerrstruct('opc:obj2mfile:syntaxerror'));
end
% Check that object is valid
if ~isvalid(objects),
    rethrow(mkerrstruct('opc:obj2mfile:objinvalid'));
end
% Check filename is a char
if ~ischar(filename)
    rethrow(mkerrstruct('opcda:obj2mfile:filenamearg'));
end
% Check for additional args, backwards
mode = 'modified';
syntax = 'set';
while length(varargin)>=1
    if ~ischar(varargin{1}),
        rethrow(mkerrstruct('opcda:obj2mfile:obj2marg'));
    end
    switch(lower(varargin{1}))
        case {'all' 'modified'}
            mode = varargin{1};
        case {'set' 'dot'}
            syntax = varargin{1};
        otherwise
            rethrow(mkerrstruct('opcda:obj2mfile:badarg', sprintf('Bad argument %s', varargin{1})));
    end
    varargin(1)=[];
end

% Open the file for writing
[pathName, fName, fExt] = fileparts(filename);
if isempty(fExt),
    filename = sprintf('%s.m', filename);
end
[fid, fidMsg] = fopen(filename, 'w');
if fid<0,
    rethrow(mkerrstruct('opcda:obj2mfile:fileopen', fidMsg));
end

% Now we make up a struct to pass around:
ai.fName = fName;
ai.fid = fid;
ai.pathName = pathName;
ai.mode = mode;
ai.syntax = syntax;
ai.daNames = {};
try
    ai = writeheader(ai);
    ai = writecreatetime(ai);
    % Call the recursive NEEDSMATFILE function
    if needsmatfile(objects, false),
        ai = writeloadmat(ai);
    end
    ai = writeopcda(ai, objects);
    ai = writeoutputhandler(ai);
catch
    fclose(fid);
    rethrow(mkerrstruct(lasterror));
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = writeheader(s)
%WRITEHEADER Writes out a header for the construction function
fid = s.fid;
fName = s.fName;
fprintf(fid, 'function out = %s\n', fName);
fprintf(fid, '%%%s M-Code for creating an OPCDA object.\n', upper(fName));
fprintf(fid, '%%   \n');
fprintf(fid, '%%   This is the machine generated representation of an OPCDA object.\n');
fprintf(fid, '%%   This M-file, %s.M, was generated from the OBJ2MFILE function.\n', upper(fName));
fprintf(fid, '%%   A MAT-file is created if the object''s UserData property is not \n');
fprintf(fid, '%%   empty or if any of the callback properties are set to a cell array  \n');
fprintf(fid, '%%   or to a function handle. The MAT-file will have the same name as the \n');
fprintf(fid, '%%   M-file but with a .MAT extension. To recreate this OPCDA object,\n');
fprintf(fid, '%%   type the name of the M-file, %s, at the MATLAB command prompt.\n', fName);
fprintf(fid, '%%   \n');
fprintf(fid, '%%   The M-file, %s.M and its associated MAT-file, %s.MAT (if\n', fName, fName);
fprintf(fid, '%%   it exists) must be on your MATLAB PATH. For additional information\n');
fprintf(fid, '%%   on setting your MATLAB PATH, type ''help addpath'' at the MATLAB \n');
fprintf(fid, '%%   command prompt.\n');
fprintf(fid, '%%   \n');
fprintf(fid, '%%   Example: \n');
fprintf(fid, '%%       newDA = %s;\n', fName);
fprintf(fid, '%%   \n');
fprintf(fid, '%%   See also OBJ2MFILE.\n');
fprintf(fid, '%%   \n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = writecreatetime(s)
%WRITECREATETIME Writes out the current date and time.
fid = s.fid;
fprintf(fid, '\n');
fprintf(fid, '%% File created: %s\n\n', datestr(now));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = writeloadmat(s)
%WRITELOADMAT Writes out the MAT file loading commands.
fid = s.fid;
fName = s.fName;
fprintf(fid, '%% Load the MAT-file which contains UserData and callback property values.\n');
fprintf(fid, 'load %s\n\n', fName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = writeoutputhandler(s)
%WRITEOUTPUTHANDLER Writes out the output handler code
fid = s.fid;
objName = s.daNames;
fprintf(fid, 'if nargout > 0 \n');
allNames = sprintf('%s ', objName{:});
allNames(end)=[];
fprintf(fid, '    out = [%s]; \n', allNames);
fprintf(fid, 'end\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function need = needsmatfile(objects, need)
% Recursive function to find out if objects require a MAT file.
if need || isempty(objects),
    return;
end
uddObj = getudd(objects);
for thisUDD = uddObj(:)'
    matProps = getmatprops(thisUDD);
    if ~isempty(matProps),
        need = true;
        break;
    end
    % Now query my children (if I have any)
    switch class(thisUDD)
        case 'opc.opcda'
            need = needsmatfile(thisUDD.Group, need);
        case 'opc.dagroup'
            need = needsmatfile(thisUDD.Item, need);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function matProps = getmatprops(uddObj)
%GETMATPROPS returns all properties that need saving to MAT
matProps = {};
if ~isempty(uddObj.UserData)
    matProps{end+1} = 'UserData';
end
% Now check for callback functions
allProps = get(uddObj);
propName = fieldnames(allProps);
for k=1:length(propName),
    thisProp = propName{k};
    if (length(thisProp)>3) && (strcmp(thisProp(end-2:end), 'Fcn')) && ...
            iscell(allProps.(thisProp))
        matProps{end+1} = thisProp;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = writeopcda(s, daVec)
%WRITEOPCDA Writes out the OPCDA objects contained in daVec
uddObj = getudd(daVec);
s.objNum.opcda = 0;
s.objNum.dagroup = 0;
s.objNum.daitem = 0;
s.matWritten = false;
autoProps = {'Name'};   % Automatically configured properties
for k=1:length(uddObj);
    s.objNum.opcda = s.objNum.opcda+1;
    objName = sprintf('daobj%d', s.objNum.opcda);
    % Write my comment
    fprintf(s.fid, '%% Create the OPCDA object - %s\n', objName);
    % Write my constructor: The string is always objName, props{:}
    constructor.string = '%s = opcda(''%s'', ''%s'');\n';
    constructor.props = {'Host', 'ServerID'};
    % Write my constructor and all required properties.
    s = writeobj(s, uddObj(k), objName, constructor, autoProps); 
    % Now write my children
    fprintf(s.fid, '\n');
    s = writegroups(s, uddObj(k).Group, objName);
    s.daNames{end+1} = objName;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = writegroups(s, grpVec, parentName)
%WRITEGROUPS Writes out the DAGROUP objects contained in grpVec
if isempty(grpVec),
    return;
end
uddObj = getudd(grpVec);
autoProps = {};
for k=1:length(uddObj);
    s.objNum.dagroup = s.objNum.dagroup+1;
    objName = sprintf('grp%d', s.objNum.dagroup);
    % Write my comment
    fprintf(s.fid, '%% Create the Group object - %s\n', objName);
    % Write my constructor: The string is always objName, props{:}
    constructor.string = ['%s = addgroup(', parentName, ', ''%s'');\n'];
    constructor.props = {'Name'};
    % Write my constructor and all required properties.
    writeobj(s, uddObj(k), objName, constructor, autoProps); 
    % Now write my children
    fprintf(s.fid, '\n');
    s = writeitems(s, uddObj(k).Item, objName);
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = writeitems(s, itmVec, parentName)
%WRITEITEMS Writes out the DAITEM objects contained in itmVec
if isempty(itmVec),
    return;
end
uddObj = getudd(itmVec);
autoProps = {};
for k=1:length(uddObj);
    s.objNum.daitem = s.objNum.daitem+1;
    objName = sprintf('itm%d', s.objNum.daitem);
    % Write my comment
    fprintf(s.fid, '%% Create the Item object - %s\n', objName);
    % Write my constructor: The string is always objName, props{:}
    constructor.string = ['%s = additem(', parentName, ', ''%s'');\n'];
    constructor.props = {'ItemID'};
    % Write my constructor and all required properties.
    s = writeobj(s, uddObj(k), objName, constructor, autoProps); 
    fprintf(s.fid, '\n');
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = writeobj(s, uddObj, objName, constructor, autoProps)
% WRITEOBJ Writes out an object's constructor and properties
% Get the constructor's values
daConstrVals = get(uddObj, constructor.props);
fprintf(s.fid, constructor.string, objName, daConstrVals{:});
% Now write all properties necessary
pInfo = propinfo(uddObj);
props = get(uddObj);
propNames = fieldnames(pInfo);
% Find out which properties need MAT files
matProps = getmatprops(uddObj);
% Perform set diffs for the automatic and the constructor properties
propNames = setdiff(propNames, autoProps);
propNames = setdiff(propNames, constructor.props);
for k=1:length(propNames)
    thisPropName = propNames{k};
    thisRO = pInfo.(thisPropName).ReadOnly;
    thisDefault = pInfo.(thisPropName).DefaultValue;
    thisValue = props.(thisPropName);
    % Don't write readonly always properties
    % Don't write if mode is 'modified' and prop is default value
    if ~strcmp(thisRO, 'always') && ...
            ~(strcmp(s.mode, 'modified') && isequal(thisDefault, thisValue))
        % Decide how to write the property.
        switch s.syntax
            case 'set'
                pStr = 'set(%s, ''%s'', %s);\n';
            case 'dot'
                pStr = '%s.%s = %s;\n';
            otherwise
                rethrow(mkerrstruct('opc:obj2mfile:modearg'));
        end
        % Now we decide how to write the value
        if ~any(strncmp(thisPropName, matProps, length(thisPropName))),
            switch class(thisValue)
                case 'char'
                    valStr = sprintf('''%s''', thisValue);
                case 'function_handle'
                    valStr = sprintf('@%s', func2str(thisValue));
                otherwise
                    % It's a number; write as a mat2str!
                    valStr = mat2str(thisValue);
            end
        else
            % Write this property to the MAT file and set the valStr
            valStr = sprintf('%s%s', objName, thisPropName);
            s = writematfile(s, valStr, thisValue);
        end
        % Now just write it!
        fprintf(s.fid, pStr, objName, thisPropName, valStr);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = writematfile(s, varName, value)
%WRITEMATFILE Writes a value to a variable in a MAT file
eval([varName ' = value;'])
matName = fullfile(s.pathName, s.fName);
if s.matWritten,
    save(matName, varName, '-append');
else
    % Create new MAT-file.
    save(matName, varName);
    s.matWritten = true;
end
