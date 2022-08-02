function obj2mfile(objects, filename, varargin)
%OBJ2MFILE Convert a video input object to MATLAB code.
%
%   OBJ2MFILE(OBJ, 'FILENAME') converts a video input object, OBJ,
%   or array of objects to an equivalent MATLAB code using the SET syntax.
%   OBJ2MFILE saves the code in file, FILENAME and will recreate the object
%   if it is executed. If FILENAME's extension is not specified or if it
%   has an extension of something other than a MATLAB extension (.m), a
%   MATLAB extension will be added to the end of FILENAME. By default
%   OBJ2MFILE will reuse an existing object and will configure only those
%   properties that are not set to their default value.
%
%   OBJ2MFILE(OBJ, 'FILENAME', 'SYNTAX') converts a video input object,
%   OBJ, or array of objects to an equivalent MATLAB code using the
%   specified SYNTAX.  Valid SYNTAX values are 'set' and 'dot'. If SYNTAX
%   is 'set', OBJ2MFILE will configure the object using the SET function.
%   If SYNTAX is 'dot', OBJ2MFILE will configure the object's properties
%   using the dot (.) notation.
%
%   OBJ2MFILE(OBJ, 'FILENAME', 'MODE')
%   OBJ2MFILE(OBJ, 'FILENAME", 'SYNTAX', 'MODE') converts a video input
%   object, OBJ, or array of objects to an equivalent MATLAB code.
%   OBJ2MFILE will configure the properties using the specified MODE. Valid
%   MODE values are 'modified' and 'all'. If MODE is 'modified', only
%   properties that are not set to their default values will be configured.
%   If MODE is 'all', all properties will be configured. OBJ2MFILE will
%   configure these properties using the specified SYNTAX and only those
%   properties that are not read-only. If SYNTAX is not specified, the
%   default SYNTAX  setting  'set' will be used.
%
%   OBJ2MFILE(OBJ,'FILENAME','REUSE')
%   OBJ2MFILE(OBJ,'FILENAME','SYNTAX','MODE','REUSE') converts a video
%   input object, OBJ, or array of objects to an equivalent MATLAB code.
%   OBJ2MFILE will search for or create an object depending on the REUSE
%   setting. Valid REUSE values are 'reuse' and 'create'. If REUSE is
%   'reuse', OBJ2MFILE will attempt to find and modify an existing object.
%   If no objects can be found, the object will be created.  If REUSE is
%   'create', OBJ2MFILE will create the object regardless of whether there
%   are existing objects. OBJ2MFILE will configure the object using the
%   specified SYNTAX and MODE settings. If SYNTAX and MODE are not
%   specified, the default SYNTAX setting 'set' and the default MODE
%   setting 'modified' will be used.
%
%   OBJ2MFILE simplifies the process of restoring an object with specific
%   property settings by eliminating the need to explicitly configure each
%   property. This function can also be looked upon as a starting point for
%   creating video input objects, accessing the objects' video sources, and
%   accessing and configuring their property values.
%
%   There is an existing object only if the object's DeviceID, VideoFormat,
%   and Tag properties are the same as the object being created and only if
%   their adaptor name is the same.
%
%   OBJ2MFILE will restore both the video input object and its video
%   source property values. However, values of read-only properties will not be
%   restored. Therefore, if an object is saved with a Logging property of
%   'on', the object will be recreated with a Logging property of 'off'
%   (the default value). PROPINFO can be used to determine if a property is
%   read-only.
%
%   If OBJ's UserData property is not empty or if any of the callback
%   properties are set to a cell array or to a function handle, then the
%   data stored in those properties are written to a MAT-file when the
%   video input object is converted and saved. The MAT-file has the
%   same name as the M-file containing the video input object code.
%
%   To recreate OBJ, execute the M-file by calling its filename.  
%
%   Example:
%       % Create a video input object.
%       vidobj = videoinput('winvideo', 1, 'RGB24_640x480');
%
%       % Configure the object's properties.
%       set(vidobj, 'FramesPerTrigger', 100);
%       set(vidobj, 'FrameGrabInterval', 2);
%       set(vidobj, 'Tag', 'CAM1');
%
%       % Access the object's selected video source.
%       src = getselectedsource(vidobj);
%
%       % Configure the object's video source properties.
%       set(src, 'Contrast', 85);
%       set(src, 'Saturation', 125);
%
%       % Save the object along with its video source properties.
%       obj2mfile(vidobj, 'myvidobj.m', 'set', 'modified');
%   
%       % Delete the object and clear it from the workspace.
%       delete(vidobj);
%       clear vidobj;
%
%       % Recreate the object.
%       vidObj = myvidobj;
%
%   See also IMAQHELP IMAQDEVICE/PROPINFO, VIDEOINPUT,
%   IMAQDEVICE/GETSELECTEDSOURCE, IMAQDEVICE/SET, IMAQDEVICE/DELETE,
%   IMAQ/PRIVATE/CLEAR.

%   KL 06-24-02
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:26 $

% Check number of input arguments.
error(nargchk(2,5, nargin, 'struct'));

% Valid setting values.
validSettings.Syntax = {'set', 'dot'};
validSettings.Mode = {'modified', 'all'};
validSettings.Reuse = {'reuse', 'create'};

% Check input arguments.
try
    localInputErrorChecking(objects, filename, validSettings, varargin{:});
catch
    rethrow(lasterror);
end

% Determine SYNTAX, MODE, and REUSE setting values.
[syntax, mode, reuse] = localDetermineSettings(validSettings, varargin{:});

% If FILENAME is not a MATLAB (.m) file, convert it to a MATLAB file.
[filename file] = localConvert2Mfilename(filename);

% Open file FILENAME for writing.
fid = fopen(filename, 'w');
if (fid==-1)
    errID = 'imaq:obj2mfile:fileopen';
    error(errID, [filename, ' could not be created.']);
end

% Convert object array to cell array.
[vidObjects, srcObjects] = localGetVidandSrcObjects(objects);

% Save the number specified video input objects.
numVideoInputObjects =length(vidObjects);

% Save property names and values for all specified video input objects and
% their video source objects.
for i = 1:numVideoInputObjects
    objPropNamesAndValues{i} = get(vidObjects{i});
    objPropInfo{i} = propinfo(vidObjects{i});
    for j = 1:length(srcObjects{i})
        srcPropNamesAndValues{i}{j} = get(srcObjects{i}(j));
        srcPropInfo{i}{j} = propinfo(srcObjects{i}(j));
    end
end


% Loop through each object and determine if a MAT file needs to be created.
% A MAT-file will contain any UserData, function handle, or cell array
% property values.

% Flag for whether a MAT-file needs to be created.
createMAT = false;
% Index value relating to the current object.
objIndex = 1;
while ~createMAT
    if ~isempty(objPropNamesAndValues{objIndex}.UserData)
        % User Data is not empty. A MAT-file needs to be created.
        createMAT = true;
        break;
    else
        propValues = struct2cell(objPropNamesAndValues{objIndex});
        
        % Query through all the property field values.
        % If any property contains a function handle or a cell
        % array then we need to create a MAT-file.
        for j = 1:length(propValues)
            % Check if any property value is a cell array or a function
            % handle.
            if (iscell(propValues{j}) || isa(propValues{j}, 'function_handle'))
                % A MAT-file needs to be created.
                createMAT = true;
                break;
            end %if
        end %for
        
        % Increment counter variable, objIndex, so we can check the next
        % object.
        objIndex = objIndex + 1;
        
    end %if
end %while
    
% Start of M-CODE

try
    % Write the M-CODE for the function header.
    fprintf(fid, 'function out = %s\n', file);
catch
    % Could not write to the output file.
    errorMsg = sprintf('Unable to write to file %s.', upper(filename));
    error('imaq:obj2mfile:fileWrite', errorMsg);
end %try

% Write general function help comment in M-CODE.
localSetMCodeHelpComment(fid, file, 'vidobj');

try
    % M-Code string for checking that the image acquisition toolbox exist.
    checkForIMAQToolboxMcodeStr = sprintf([...
        '%% Check if we could check out a license for the Image Acquisition Toolbox.\n',...
        'canCheckoutLicense = license(''checkout'', ''Image_Acquisition_Toolbox'');\n',...
        '\n',...
        '%% Check if the Image Acquisition Toolbox is installed.\n',...
        'isToolboxInstalled = exist(''videoinput'', ''file'');\n',...
        '\n',...
        'if ~(canCheckoutLicense && isToolboxInstalled)\n',...
        '    %% Toolbox could not be checked out or toolbox is not installed.\n',...
        '    errID = ''imaq:obj2mfile:invalidToolbox'';\n',...
        '    error(errID, ''Image Acquisition Toolbox is not installed.'');\n',...
        'end\n\n']);

    % Write the M-CODE for checking the Image Acquisition Toolbox.
    fprintf(fid, '%s', checkForIMAQToolboxMcodeStr);
catch
    % Could not write to the output file.
    errorMsg = sprintf('Unable to write to file %s.', upper(filename));
    error('imaq:obj2mfile:fileWrite', errorMsg);
end %try


% M-Code for loading the MAT-file.
if (createMAT)
    % A MAT-file was created.
    try
        % M-Code string for loading the MAT-file.
        loadMAT_McodeStr = sprintf([...
            '%% Load the MAT-file containing UserData and CallBack property values.\n',...
            'try\n',...
            '    MATvar = load(''%s'');\n',...
            '    MATLoaded = true;\n',...
            'catch\n',...
            '    warnMsg = ([''MAT-file could not be loaded. Object Properties whose values'',...\n',...
            '        ''were saved in the MAT-file will instead be configured to their default value.'']);\n',...
            '    warning(warnMsg, ''imaq:obj2mfile:MATload'');\n',...
            '   MATLoaded = false;\n',...
            'end\n\n'], file);
        
        % Write the M-CODE for loading the MAT-file.
        fprintf(fid, '%s', loadMAT_McodeStr);
    catch
        % Could not write to the output file.
        errorMsg = sprintf('Unable to write to file %s.', upper(filename));
        error('imaq:obj2mfile:fileWrite', errorMsg);
    end %try
end %if

% Flag for whether a MAT-file was created. A MAT-file is created the
% first time data is saved to it. If a MAT-file is created, then we
% want to make sure subsequent data are appended to the file instead of
% overwriting the file.
matFileCreated = false;

% The array of objects names to return is initially empty.
outObjStr = [];

% M-Code for recreating objects.
% Query through each object specified by OBJ
for i = 1:numVideoInputObjects 
    
    % Object names to use in M-Code.
    existobjName = sprintf('existingObjs%d', i);
    objName = sprintf('vidObj%d', i);
    
    % Object's Device Properties.
    objhwinfo = imaqhwinfo(vidObjects{i});
    adaptor = objhwinfo.AdaptorName;
    id = objPropNamesAndValues{i}.DeviceID;
    tag = objPropNamesAndValues{i}.Tag;
    format = objPropNamesAndValues{i}.VideoFormat;
    
    videoinputStr = sprintf('videoinput(adaptorName, deviceID, vidFormat)');
    imaqfindStr = sprintf('imaqfind(''DeviceID'', deviceID, ''VideoFormat'', vidFormat, ''Tag'', tag)');
    
    try
        % M-CODE string defining an object's AdaptorName, DeviceID,
        % VideoFormat, and Tag values.
        objInfoMCodeStr = sprintf('\n');
        objInfoMCodeStr = sprintf('%s%% Device Properties.\n', objInfoMCodeStr);
        objInfoMCodeStr = sprintf('%sadaptorName = ''%s'';\n', objInfoMCodeStr, adaptor);
        objInfoMCodeStr = sprintf('%sdeviceID = %d;\n', objInfoMCodeStr, id);
        objInfoMCodeStr = sprintf('%svidFormat = ''%s'';\n', objInfoMCodeStr, format);
        objInfoMCodeStr = sprintf('%stag = ''%s'';\n', objInfoMCodeStr, tag);
        objInfoMCodeStr = sprintf('%s\n', objInfoMCodeStr);

        % Write the M-CODE for defining an object's AdaptorName, DeviceID,
        % VideoFormat, and Tag values.
        fprintf(fid, '%s', objInfoMCodeStr);
    catch
        % Could not write to the output file.
        errorMsg = sprintf('Unable to write to file %s.', upper(filename));
        error('imaq:obj2mfile:fileWrite', errorMsg);
    end %try
 
    if strcmp(reuse, 'reuse')
        try
            % M-CODE string for reusing an existing video input object.
            reuseMcodeStr = sprintf('%% Search for existing video input objects.\n');
            reuseMcodeStr = sprintf('%s%s = %s;\n\n', reuseMcodeStr, existobjName, imaqfindStr);
            reuseMcodeStr = sprintf('%sif isempty(%s)\n', reuseMcodeStr, existobjName);
            reuseMcodeStr = sprintf('%s    %% If there are no existing video input objects, construct the object.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %s = %s;\n', reuseMcodeStr, objName, videoinputStr);
            reuseMcodeStr = sprintf('%selse\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% There are existing video input objects in memory that have the same\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% DeviceID, VideoFormat, and Tag property values as the object we are\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% recreating. If any of those objects contains the same AdaptorName\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% value as the object being recreated, then we will reuse the object.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% If more than one existing video input object contains that\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% AdaptorName value, then the first object found will be reused. If\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% there are no existing objects with the AdaptorName value, then the\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% video input object will be created.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% Query through each existing object and check that their adaptor name\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    %% matches the adaptor name of the object being recreated.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    for i = 1:length(%s)\n', reuseMcodeStr, existobjName);
            reuseMcodeStr = sprintf('%s        %% Get the object''s device information.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s        objhwinfo = imaqhwinfo(%s{i});\n', reuseMcodeStr, existobjName);
            reuseMcodeStr = sprintf('%s        %% Compare the object''s AdaptorName value with the AdaptorName value\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s        %% being recreated.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s        if strcmp(objhwinfo.AdaptorName, adaptorName)\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s            %% The existing object has the same AdaptorName value as the\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s            %% object being recreated. So reuse the object.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s            %s = %s{i};\n', reuseMcodeStr, objName, existobjName);
            reuseMcodeStr = sprintf('%s            %% There is no need to check the rest of existing objects.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s            %% Break out of FOR loop.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s            break;\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s        elseif(i == length(%s))\n', reuseMcodeStr, existobjName);
            reuseMcodeStr = sprintf('%s            %% We have queried through all existing objects and no\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s            %% AdaptorName values matches the AdaptorName value of the\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s            %% object being recreated. So the object must be created.\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s            %s = %s;\n', reuseMcodeStr, objName, videoinputStr);
            reuseMcodeStr = sprintf('%s        end %%if\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%s    end %%for\n', reuseMcodeStr);
            reuseMcodeStr = sprintf('%send %%if\n\n', reuseMcodeStr);

            % Write the M-CODE for reusing an existing video input object.
            fprintf(fid, '%s', reuseMcodeStr);
        catch
            % Could not write to the output file.
            errorMsg = sprintf('Unable to write to file %s.', upper(filename));
            error('imaq:obj2mfile:fileWrite', errorMsg);
        end %try
    elseif strcmp(reuse, 'create')       
        try
            % M-CODE string for creating a video input object.
            createMcodeStr = sprintf('%% Create the video input object.\n');
            createMcodeStr = sprintf('%s%s = %s;\n\n', createMcodeStr, objName, videoinputStr);

            % Write the M-CODE for creating a video input object.
            fprintf(fid, '%s', createMcodeStr);
        catch
            % Could not write to the output file.
            errorMsg = sprintf('Unable to write to file %s.', upper(filename));
            error('imaq:obj2mfile:fileWrite', errorMsg);
        end %try
    end %if
    
    % M-CODE for configuring an object's properties.  
    
    % Write Code to configure properties values that were saved to a
    % MAT-file.  If the MAT-file does not exist, it's default value shall
    % be saved. 
    [objProps{i}, objMATProps{i}] = localGetPropertiesToConfigure(objPropNamesAndValues{i}, objPropInfo{i}, mode);

    if (length(objMATProps{i}) > 0)
        try
            % M-CODE string for configuring properties whose values were
            % saved in a MAT-file.
            configMATPropLoadedMcodeStr = sprintf('%% Configure properties whose values are saved in %s.mat.\n', file);
            configMATPropLoadedMcodeStr = sprintf('%sif (MATLoaded)\n', configMATPropLoadedMcodeStr);
            configMATPropLoadedMcodeStr = sprintf('%s    %% MAT-file loaded successfully. Configure the properties whose values\n', configMATPropLoadedMcodeStr);
            configMATPropLoadedMcodeStr = sprintf('%s    %% are saved in the MAT-file.\n', configMATPropLoadedMcodeStr);
            fprintf(fid, '%s', configMATPropLoadedMcodeStr);
            MATLoaded = true;
            matFileCreated = localConfigurePropertyMCode(fid, objName, i, syntax, objMATProps{i}, objPropNamesAndValues{i}, file, matFileCreated, MATLoaded);

            % M-CODE string for configuring properties whose values were
            % saved in the MAT-file to their default value.
            configMATPropNotLoadedMcodeStr = sprintf('else\n');
            configMATPropNotLoadedMcodeStr = sprintf('%s   %% MAT-file could not be loaded. Configure properties whose values were\n',configMATPropNotLoadedMcodeStr);
            configMATPropNotLoadedMcodeStr = sprintf('%s   %% saved in the MAT-file to their default value.\n', configMATPropNotLoadedMcodeStr);
            fprintf(fid, '%s', configMATPropNotLoadedMcodeStr);
            MATLoaded = false;
            for k = 1:length(objMATProps{i})
                propertyinfo = objPropInfo{i}.(objMATProps{i}{k});
                objPropNamesAndValues{i}.(objMATProps{i}{k}) = propertyinfo.DefaultValue;
            end %for
            matFileCreated = localConfigurePropertyMCode(fid, objName, i, syntax, objMATProps{i}, objPropNamesAndValues{i}, file, matFileCreated, MATLoaded);
            fprintf(fid, 'end\n\n');
        catch
            % Could not write to the output file.
            errorMsg = sprintf('Unable to write to file %s.', upper(filename));
            error('imaq:obj2mfile:fileWrite', errorMsg);
        end %try
    end %if
    
    if(length(objProps{i}) > 0)
        % Query through properties that need to be saved.
        try
            configPropCommentMcodeStr = sprintf('%% Configure %s properties.\n', objName);
            fprintf(fid, '%s', configPropCommentMcodeStr);
            % Write the M-Code for configuring the video input object's
            % properties.
            matFileCreated = localConfigurePropertyMCode(fid, objName, i, syntax, objProps{i}, objPropNamesAndValues{i}, file, matFileCreated, MATLoaded);
            fprintf(fid, '\n');
        catch
            % Could not write to the output file.
            errorMsg = sprintf('Unable to write to file %s.', upper(filename));
            error('imaq:obj2mfile:fileWrite', errorMsg);
        end %try
    end %if
    
    % M-CODE for accessing an object's video source.
    try
        srcName = sprintf('srcObj%d', i);
        configSrcCommentMcodeStr = sprintf('%% Configure %s''s video source properties.\n', objName);
        fprintf(fid, '%s', configSrcCommentMcodeStr);

        if strcmpi(syntax, 'set')
            % Get the video source object using the SET sytax.
            getVidSrcObjBySetStr = sprintf('%s = get(%s, ''Source'');\n', srcName, objName);
            fprintf(fid, '%s', getVidSrcObjBySetStr);
        else
            % Get the video source object using the DOT syntax.
            getVidSrcObjByDotStr = sprintf('%s =  %s.Source;\n', srcName, objName);
            fprintf(fid, '%s', getVidSrcObjByDotStr);
        end %if
    catch
        % Could not write to the output file.
        errorMsg = sprintf('Unable to write to file %s.', upper(filename));
        error('imaq:obj2mfile:fileWrite', errorMsg);
    end %try

    % Write the M-Code for configuring an object's video source properties.
    try
        for j = 1:length(srcObjects{i})
            % Query through an object's video sources.
            % Extract source properties that differ from their default
            % values.
            [srcProps, srcMATProps] = localGetPropertiesToConfigure(srcPropNamesAndValues{i}{j}, srcPropInfo{i}{j}, mode);

            if (length(srcMATProps) > 0)
                % Write the M-Code to configure video source properties values that
                % were saved to a MAT-file. If the MAT-file does not exist, its
                % default value shall be saved.
                configMATPropLoadedMcodeStr = sprintf('%% Configure properties whose values are saved in %s.mat.\n', file);
                configMATPropLoadedMcodeStr = sprintf('%sif (MATLoaded)\n', configMATPropLoadedMcodeStr);
                configMATPropLoadedMcodeStr = sprintf('%s    %% MAT-file loaded successfully. Configure the properties whose values\n', configMATPropLoadedMcodeStr);
                configMATPropLoadedMcodeStr = sprintf('%s    %% are saved in the MAT-file.\n', configMATPropLoadedMcodeStr);
                fprintf(fid, '%s', configMATPropLoadedMcodeStr);
                MATLoaded = true;
                matFileCreated = localConfigurePropertyMCode(fid, srcName, i, syntax, srcMATProps, srcPropNamesAndValues{i}{j}, file, matFileCreated, MATLoaded);

                % M-CODE string for configuring properties whose values
                % were saved in the MAT-file to their default value.
                configMATPropNotLoadedMcodeStr = sprintf('else\n');
                configMATPropNotLoadedMcodeStr = sprintf('%s   %% MAT-file could not be loaded. Configure properties whose values were\n',configMATPropNotLoadedMcodeStr);
                configMATPropNotLoadedMcodeStr = sprintf('%s   %% were saved in the MAT-file to their default value.\n', configMATPropNotLoadedMcodeStr);
                fprintf(fid, '%s', configMATPropNotLoadedMcodeStr);
                MATLoaded = false;
                for k = 1:length(srcMATProps)
                    propertyinfo = srcPropInfo{i}{j}.(srcMATProps{k});
                    objPropNamesAndValues{i}.(srcMATProps{k}) = propertyinfo.DefaultValue;
                end %for

                matFileCreated = localConfigurePropertyMCode(fid, srcName, i, syntax, srcMATProps{i}, objPropNamesAndValues{i}{j}, file, matFileCreated, MATLoaded);
                fprintf(fid, 'end\n\n');
            end %if  
            
            % Configure properties whose values weren't saved in the MAT.
            if (length(srcProps) > 0)
                src = sprintf('%s(%d)', srcName, j);
                matFileCreated = localConfigurePropertyMCode(fid, src, i, syntax, srcProps, srcPropNamesAndValues{i}{j}, file, matFileCreated);
            end %if
            
        end %for
      
        fprintf(fid, '\n\n');

    catch
        % Could not write to the output file.
        errorMsg = sprintf('Unable to write to file %s.', upper(filename));
        error('imaq:obj2mfile:fileWrite', errorMsg);
    end %try
    
    outObjStr = [outObjStr sprintf('vidObj%d ', i)];
end

% M-CODE for returning objects.
try
    if (i == 1)
        % M-Code string for returning a single object.
        % Do not concatenate the object with brackets for performance.
        returnObjStr = sprintf('out = %s;\n', outObjStr);
    else
        % M-Code string for returning multiple objects.
        % Must concatenate the objects with brackets.
        returnObjStr = sprintf('out = [%s];\n', outObjStr);
    end %if
    
    % Write the M-CODE for returning the video input objects.
    fprintf(fid, '%s', returnObjStr);
catch
    % Could not write to the output file.
    errorMsg = sprintf('Unable to write to file %s.', upper(filename));
    error('imaq:obj2mfile:fileWrite', errorMsg);
end %try

% Close the file.
fclose(fid);

% -------------------------------------------------------------------------
function localInputErrorChecking(objects, filename, validSettings, varargin)
% Checks specified input arguments for the following:
% * Make sure that OBJ is a valid video input object.
% * Check that FILENAME is specified as a string.
% * Check that all SETTING values are specified as strings.
% * Check that SETTING values agree with the different OBJ2MFILE function formats.

% -----CHECK FOR VIDEO INPUT OBJECT VALIDITY-----

% Check if OBJ is a video input object or a video source object.
if ~isa(objects, 'imaqdevice')
    % OBJ is a video source object.
    errID = 'imaq:obj2mfile:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
end 

% Check if OBJ is an image acquisition object.
if ~all(isvalid(objects))
    errID = 'imaq:obj2mfile:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
end %if

% -----CHECK FOR FILENAME VALIDITY-----

% Check that FILENAME is a string.
if ~ischar(filename)
    errID = 'imaq:obj2mfile:nonStringFILENAME';
    error(errID, imaqgate('privateMsgLookup',errID));
end 

% -----CHECK FOR SYNTAX, MODE, AND REUSE SETTING VALIDITY-----

% Check that setting inputs are all strings.
if ~iscellstr(varargin)
    errID = 'imaq:obj2mfile:nonStringSetting';
    error(errID, imaqgate('privateMsgLookup',errID));
end

if length(varargin) == 1,
    % Only one setting is specified.
    % OBJ2MFILE(OBJ, 'FILENAME', 'SETTING1') 
    validSettings.All = [validSettings.Syntax, validSettings.Reuse, validSettings.Mode];
    if isempty(strmatch(lower(varargin{1}), validSettings.All));
       % SETTING1 can contain a value for either SYNTAX, MODE, or REUSE.
       errID = 'imaq:obj2mfile:invalidSetting';
       error(errID, imaqgate('privateMsgLookup',errID));
    end %if
elseif length(varargin) == 2,
    % Two settings are specified.
    % OBJ2MFILE(OBJ, 'FILENAME', 'SETTING1', 'SETTING2')
    if isempty(strmatch(lower(varargin{1}), validSettings.Syntax))
        % SETTING1 must contain a value for SYNTAX.
        errID = 'imaq:obj2mfile:invalidSYNTAX';
        error(errID, imaqgate('privateMsgLookup', errID));
    elseif isempty(strmatch(lower(varargin{2}), validSettings.Mode))
        % SETTING2 must contain a value for MODE.
        errID = 'imaq:obj2mfile:invalidMODE';
        error(errID, imaqgate('privateMsgLookup', errID));
    end %if
elseif length(varargin) == 3,
    % Three settings are specified.
    % OBJ2MFILE(OBJ, 'FILENAME', 'SETTING1', 'SETTING2', 'SETTING3')
    if isempty(strmatch(lower(varargin{1}), validSettings.Syntax))
        % SETTING1 must contain a value for SYNTAX.
        errID = 'imaq:obj2mfile:invalidSYNTAX';
        error(errID, imaqgate('privateMsgLookup', errID));
    elseif isempty(strmatch(lower(varargin{2}), validSettings.Mode))
        % SETTING2 must contain a value for MODE.
        errID = 'imaq:obj2mfile:invalidMODE';
        error(errID, imaqgate('privateMsgLookup', errID));
    elseif isempty(strmatch(lower(varargin{3}), validSettings.Reuse))
        % SETTING3 must contain a value for REUSE.
        errID = 'imaq:obj2mfile:invalidREUSE';
        error(errID, imaqgate('privateMsgLookup', errID));
    end %if
else 
    % More than three settings specified.
    errID = 'imaq:obj2mfile:tooManySettings';
    error(errID, imaqgate('privateMsgLookup', errID));
end

% -------------------------------------------------------------------------
function [syntax, mode, reuse] = localDetermineSettings(validSettings, varargin)
% Determine the SYNTAX, MODE, and REUSE setting values.

% Default setting values.
syntax = 'set';
mode = 'modified';
reuse = 'reuse';

% Query specified inputs to determine setting values.
% Because STRMATCH returns true for incomplete words such as 's' or 'se'
% for 'set', it is necessary to compare only the first character of the
% user specified setting values stored in VARARGIN. 
for i = 1:length(varargin)
    if strmatch(varargin{i}, validSettings.Syntax)
        % It is a SYNTAX setting.
        if(varargin{i}(1) == 's')
            syntax = 'set';
        else
            syntax = 'dot';
        end
        continue;
    end
    
    if strmatch(varargin{i}, validSettings.Mode)
        % It is a MODE Setting.
        if(varargin{i}(1) == 'm')
            mode = 'modified';
        else
            mode = 'all';
        end
        continue;
    end
   
    if strmatch(varargin{i}, validSettings.Reuse)
        % It is a REUSE Setting.
        if(strcmp(varargin{i}(1),'reuse'))
            reuse = 'reuse';
        else
            reuse = 'create';
        end
    end
end

% -------------------------------------------------------------------------
function [filename, file] = localConvert2Mfilename(filename)
% Converts the specified FILENAME to a MATLAB M-file. If FILENAME contains
% no extension or if FILENAME contains an extension other than a MATLAB
% extension (.m), append a (.m) to the end of filename.

ext = [];

if (length(filename) >= 2)
    % Extract the last two characters of filename. If the last two
    % characters is '.m' then FILENAME contains a MATLAB extension.
    ext = filename(end-1:end);
end

% Check if the extension is a MATLAB extension.
% If the OS platform is Windows, MATLAB will see files containing
% extensions of either (.m) or (.M) as MATLAB files.
% If the OS is UNIX, only lowercase MATLAB (.m) extensions will be
% recognized as a MATLAB file.
if (ispc && ~strcmpi(ext, '.m') || isempty(ext)) 
    % Windows OS.
    % FILENAME does not contain a MATLAB extension.
    file = filename;
    % Append a '.m' to the end of the FILENAME.
    filename = [file, '.m'];
elseif (~ispc && ~strcmp(ext, '.m') || isempty(ext))
    % UNIX OS.
    % FILENAME does not contain a MATLAB extension.
    file = filename;
    % Append a '.m' to the end of FILENAME.
    filename = [file, '.m'];
else
    % FILENAME contains a MATLAB(.m) extension.
    file = filename(1:end-2);
end

% -------------------------------------------------------------------------
function [vidObjs, sourceObjs] = localGetVidandSrcObjects(objects)
%Extracts video input objects and their source objects and returns them as
%cell arrays.
for i = 1:length(objects)
    vidObjs{i} = objects(i);
    sourceObjs{i} = get(objects(i), 'Source');
end

% -------------------------------------------------------------------------
function [propFields, matPropFields] = localGetPropertiesToConfigure(currentvalue, info, mode)
% Determine the properties that need to be explicitly configured in
% generated M-Code.

allPropertyFields = fieldnames(info);
numPropFields = length(allPropertyFields);

switch mode
    case 'modified'
        % Property fields that needs to be configured is initially empty.
        % Variable nonDefaultPropertyFields is a container for property
        % names whose values need to be explicitly configured in M-Code.
        % Variable matPropertyNames is a container for property names whose
        % values will be saved in a MAT-file.
        nonDefaultPropertyNames = {};
        matPropertyNames = {};

        % Query through each property field. For MODE setting 'modified',
        % configure all non-default, non read-only properties.

        for i = 1:numPropFields
            % Extract current property's name, value, and default value.
            currentPropName = allPropertyFields{i};
            currentPropValue = currentvalue.(currentPropName);
            defaultPropValue = info.(allPropertyFields{i}).DefaultValue;

            % If the current property value is either a cell array or a
            % function handle, then add the property name to the list of
            % names whose values are stored in a MAT-file.
            if (iscell(currentPropValue) || isa(currentPropValue, 'function_handle'))
                matPropertyNames{end+1} = currentPropName;
                continue;
            end %if
            
            % If the current property name is UserData and contains a
            % non-empty value, then add it to the list of property
            % names whose values are stored in a MAT-file.
            if strcmpi(currentPropName, 'UserData'),
                if ~isempty(currentPropValue)
                    matPropertyNames{end+1} = currentPropName;
                    continue;
                end %if
            end %if

            % Property does not contain a cell array or function handle or
            % the property is an empty UserData field. Check if the
            % property field contains its default value.
            if ~isequal(currentPropValue, defaultPropValue)
                % Check if property field is read-only.
                if ~isequal(info.(allPropertyFields{i}).ReadOnly, 'always')
                    % Property is non read-only and contains a non-default
                    % value. Add property to the list of fields that needs
                    % to be configured.
                    nonDefaultPropertyNames{end+1} = currentPropName;
                end %if
            end %if
        end %for

        propFields = nonDefaultPropertyNames;
        matPropFields = matPropertyNames;
    case 'all'
        % Property fields that needs to be configured is initially empty.
        % Variable nonReadOnlyPropertyFields is a container for property
        % names whose values need to be explicitly configured in M-Code.
        % Variable matPropertyNames is a container for property names whose
        % values will be saved in a MAT-file.
        matPropertyNames = {};
        nonReadOnlyPropertyFields = {};
        
        % Query through each property field to determine which property
        % field needs to be configured. For MODEsetting 'all', configure
        % all non read-only properties.
        for j = 1:numPropFields

            % Extract current property's name, value, and read-only value.
            currentPropName = allPropertyFields{j};
            currentPropValue = currentvalue.(currentPropName);
            propertyReadOnlyStatus = info.(allPropertyFields{j}).ReadOnly;

            % Check if property field is read-only.
            if ~isequal(propertyReadOnlyStatus, 'always')

                % Current property is non read-only.
                % If the current property value is either a cell array or a
                % function handle, then add the property name to the list of
                % names whose values are stored in a MAT-file.
                if (iscell(currentPropValue) || isa(currentPropValue, 'function_handle'))
                    matPropertyNames{end+1} = currentPropName;
                    continue;
                end %if

                % If the current property name is UserData and contains a
                % non-empty value, then add it to the list of property
                % names whose values are stored in a MAT-file.
                if strcmpi(currentPropName, 'UserData'),
                    if ~isempty(currentPropValue)
                        matPropertyNames{end+1} = currentPropName;
                        continue;
                    end %if
                end %if

                % Add the property to the list of fields we need to
                % configure.
                nonReadOnlyPropertyFields{end+1} = currentPropName;
            end %if
        end %for

        propFields = nonReadOnlyPropertyFields;
        matPropFields = matPropertyNames;
end %switch

% -------------------------------------------------------------------------
function writeMAT = localConfigurePropertyMCode(fid, objName, count, syntax, prop, currentValue, file, writeMAT, MATLoaded)
% Query through an object's properties and write the M-Code for configuring
% the property value. If the property is a cell array, function handle, or
% is a UserData property value then LOCALCONFIGUREPROPERTYMCODE will write
% the property value to a MAT-file.
%
% Input Parameters: 
% fid           = file identifier;
% objName       = object name being used (ie. vidObj1, vidObj2)
% count         = counter for the current video input object.
% syntax        = SYNTAX setting.
% currentValue  = object's property names and current values.
% file          = filename excluding the extension.
% writeMAT      = flag indicating whether a MAT-file has been written.
% MATLoaded     = flag indicating whether a MAT-file has been loaded.

configPropMCodeStr = sprintf('');

for i = 1:length(prop)
    propName = prop{i};
    propValue = currentValue.(propName);

    if strcmp(propName, 'UserData')
        % UserData property is not empty. UserData values are saved in the
        % MAT-file.
        varName = ['userdata' int2str(count)];
        writeMAT = localSaveToMATFile(file, writeMAT, varName, propValue);
        if (MATLoaded),
            % Use the data loaded from the MAT-file.
            if strcmpi(syntax, 'set')
                configPropMCodeStr = sprintf('%sset(%s, ''UserData'', MATvar.%s);\n', configPropMCodeStr, objName,varName);
            else
                configPropMCodeStr = sprintf('%s%s.UserData = MATvar.%s;\n', configPropMCodeStr, objName, varName);
            end
        else
            % Value can not be loaded from the MAT-file. Use the
            % default value.
            if strcmpi(syntax, 'set')
                configPropMCodeStr = sprintf('%sset(%s, ''UserData'', []);\n', configPropMCodeStr, objName);
            else
                configPropMCodeStr = sprintf('%s%s.UserData = [];\n', configPropMCodeStr, objName);
            end
        end
        continue;
    end

    if isnumeric(propValue)&&isempty(propValue)
        % Property value is empty.
        if strcmpi(syntax, 'set')
            configPropMCodeStr = sprintf('%sset(%s, ''%s'', []);\n',configPropMCodeStr, objName, propName);
        else
            configPropMCodeStr = sprintf('%s%s.%s = [];\n', configPropMCodeStr, objName, propName);
        end
    elseif isnumeric(propValue)&& length(propValue) == 1
        % Property value a numeric scalar.
        if strcmpi(syntax, 'set')
            configPropMCodeStr = sprintf('%sset(%s, ''%s'', %g);\n',configPropMCodeStr, objName, propName, propValue);
        else
            configPropMCodeStr = sprintf('%s%s.%s = %d;\n', configPropMCodeStr, objName, propName, propValue);
        end
    elseif isnumeric(propValue)&&length(propValue)>1
        % Property value is a numeric vector.
        % Create string and remove the trailing space.
        numd = repmat('%g ',1, length(propValue));
        numd = numd(1:end-1);
        if strcmpi(syntax, 'set')
            configPropMCodeStr = sprintf(['%sset(%s, ''%s'', [' numd ']);\n'],configPropMCodeStr, objName, propName, propValue);
        else
            configPropMCodeStr = sprintf(['%s%s.%s = [' numd '];\n'],configPropMCodeStr, objName, propName, propValue);
        end
    elseif (iscell(propValue) || isa(propValue, 'function_handle'))
        % Property value is a cell or a function handle.
        % Create a variable (same name as the property) equal to
        % the property value.
        varName = [lower(propName) int2str(count)];
        writeMAT = localSaveToMATFile(file, writeMAT, varName, propValue);

        if (MATLoaded),
            % MAT-file was loaded.
            if strcmpi(syntax, 'set')
                configPropMCodeStr = sprintf('%s    set(%s, ''%s'', MATvar.%s);\n', configPropMCodeStr, objName, propName, varName);
            else
                configPropMCodeStr = sprintf('%s    %s.%s = MATvar.%s;\n', configPropMCodeStr, objName, propName, varName);
            end
        else
            % MAT-file is not loaded.
            if isa(propValue, 'function_handle')
                % Property value is a function handle.
                fcnhdleStr = ['@', func2str(propValue)];
                if strcmpi(syntax, 'set')
                    configPropMCodeStr = sprintf('%s    set(%s, ''%s'', %s);\n', configPropMCodeStr, objName, propName, fcnhdleStr);
                else
                    configPropMCodeStr = sprintf('%s    %s.%s = %s;\n', configPropMCodeStr, objName, propName, fcnhdleStr);
                end %if

            elseif iscell(propValue)
                % Property value is a cell.
                if strcmpi(syntax, 'set')
                    configPropMCodeStr = sprintf('%s    set(%s, ''%s'', %s);\n', configPropMCodeStr, objName, propName, propValue);
                else
                    configPropMCodeStr = sprintf('%s    %s.%s = %s);\n', configPropMCodeStr, objName, propName, propValue);
                end
            end %if
        end %if
    else
        % Property value is a string.
        if strcmpi(syntax, 'set')
            configPropMCodeStr = sprintf('%sset(%s, ''%s'', ''%s'');\n', configPropMCodeStr, objName,propName,propValue);
        else
            configPropMCodeStr = sprintf('%s%s.%s = ''%s'';\n',configPropMCodeStr, objName, propName, propValue);
        end
    end
end

try
    fprintf(fid, '%s', configPropMCodeStr);
catch
    % Could not write to the output file.
    errorMsg = sprintf('Unable to write to file %s.', upper(filename));
    error('imaq:obj2mfile:fileWrite', errorMsg);
end
% ------------------------------------------------------------------
function writeMAT = localSaveToMATFile(file, writeMAT, varName, value)
% Save property value to a MAT-file.

eval([varName ' = value;'])
  
% Save to a new MAT-file or append to an existing MAT-file.
if writeMAT
    % MAT-File exists.
    save(file, varName, '-append');
else
    % Create new MAT-file.
    save(file, varName);
    writeMAT = true;
end

% -------------------------------------------------------------------------
function localSetMCodeHelpComment(fid, file, name)
% Create the comments for the beginning of the generated M-file.

fcnNameUpper = upper(file);

try
    % M-Code string for the function helper comments.
    fcnHelpCommentMcodeStr = sprintf('%%%s M-Code for creating a video input object.\n', fcnNameUpper);
    fcnHelpCommentMcodeStr = sprintf('%s%%   \n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   This is the machine generated representation of a video input object.\n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   This M-file, %s.M, was generated from the OBJ2MFILE function.\n', fcnHelpCommentMcodeStr, fcnNameUpper);
    fcnHelpCommentMcodeStr = sprintf('%s%%   A MAT-file is created if the object''s UserData property is not \n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   empty or if any of the callback properties are set to a cell array  \n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   or to a function handle. The MAT-file will have the same name as the \n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   M-file but with a .MAT extension. To recreate this video input object,\n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   type the name of the M-file, %s, at the MATLAB command prompt.\n', fcnHelpCommentMcodeStr, file);
    fcnHelpCommentMcodeStr = sprintf('%s%%   \n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   The M-file, %s.M and its associated MAT-file, %s.MAT (if\n', fcnHelpCommentMcodeStr, fcnNameUpper, fcnNameUpper);
    fcnHelpCommentMcodeStr = sprintf('%s%%   it exists) must be on your MATLAB path.\n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   \n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   Example: \n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%       %s = %s;\n', fcnHelpCommentMcodeStr, name, file);
    fcnHelpCommentMcodeStr = sprintf('%s%%   \n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   See also VIDEOINPUT, IMAQDEVICE/PROPINFO, IMAQHELP, PATH.\n', fcnHelpCommentMcodeStr);
    fcnHelpCommentMcodeStr = sprintf('%s%%   \n\n', fcnHelpCommentMcodeStr);

    % Write the M-CODE for the function helper comments.
    fprintf(fid, '%s', fcnHelpCommentMcodeStr);
catch
    % Could not write to the output file.
    errorMsg = sprintf('Unable to write to file %s.', upper(filename));
    error('imaq:obj2mfile:fileWrite', errorMsg);
end %try
