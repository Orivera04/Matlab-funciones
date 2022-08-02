function out = triggerconfig(obj, varargin)
%TRIGGERCONFIG Configure video input object trigger settings.
%
%    TRIGGERCONFIG(OBJ, TYPE) 
%    TRIGGERCONFIG(OBJ, TYPE, CONDITION) 
%    TRIGGERCONFIG(OBJ, TYPE, CONDITION, SOURCE) configures the 
%    TriggerType, TriggerCondition, and TriggerSource properties of 
%    video input object OBJ to the value specified by TYPE, CONDITION, 
%    and SOURCE, respectively. 
%
%    OBJ can be a single video input object an array of video input objects. 
%    If an error occurs, any video input objects in the array that have 
%    already been configured are returned to their original configuration.
%
%    TYPE, CONDITION, and SOURCE are text strings. For a list of valid 
%    trigger configurations, use TRIGGERINFO(OBJ). CONDITION and SOURCE 
%    are optional parameters as long as a unique trigger configuration 
%    can be determined from the parameters provided.
%
%    TRIGGERCONFIG(OBJ, CONFIG) configures the TriggerType, TriggerCondition,
%    and TriggerSource property values for video input object OBJ using CONFIG, 
%    a MATLAB structure with fieldnames TriggerType, TriggerCondition, and 
%    TriggerSource, each with the desired property value. 
%
%    CONFIG = TRIGGERCONFIG(OBJ) returns a MATLAB structure, CONFIG,
%    containing OBJ's current trigger configuration. The fieldnames of CONFIG 
%    are TriggerType, TriggerCondition, and TriggerSource, each containing 
%    OBJ's current property value. OBJ must be a 1x1 object.
%
%    Example:
%       % Construct a video input object.
%       obj = videoinput('winvideo', 1);
%
%       % Configure the trigger settings.
%       triggerconfig(obj, 'manual')
%
%       % Trigger the acquisition.
%       start(obj)
%       trigger(obj)
%
%       % Remove video input object from memory.
%       delete(obj);
%
%    See also IMAQDEVICE/TRIGGERINFO, IMAQHELP. 
%

%    CP 10-07-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:37 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:triggerconfig:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~all(isvalid(obj))
    errID = 'imaq:triggerconfig:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Verify OBJ is not running.
uddobj = imaqgate('privateGetField', obj, 'uddobject');
if any(strcmp(get(uddobj, 'Running'), 'on'))
    errID = 'imaq:triggerconfig:objRunning';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Define configuration order.
trigfields = {'TriggerType', 'TriggerCondition', 'TriggerSource'};

% Only allow arrays when configuring.
nObjects = length(uddobj);
if (nargin==1) && (nObjects > 1)
    errID = 'imaq:triggerconfig:OBJ1x1';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif nargin==1,
    % S = TRIGGERCONFIG(OBJ)
    out = cell2struct(get(uddobj, trigfields), trigfields, 2);
    return;
end

% Configure each object provided. 
prevConfig = {};
for i=1:nObjects,
    try
        % Make sure to cache the previous configurations
        % before configuring the new one.
        prevConfig{i} = get(uddobj(i), trigfields);
        localConfig(trigfields, uddobj(i), varargin{:});
    catch
        % Attempt to configure back to previous settings.
        for p = 1:length(prevConfig),
            triggerconfig(uddobj(p), prevConfig{p}{:});
        end
        rethrow(lasterror);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localConfig(trigfields, uddobj, varargin)

% Parameter parsing.
userSettings = {};
switch nargin
    case 3,
        userInput = varargin{1};
        if (~isstruct(userInput) && ~ischar(userInput)) || ...
                (isstruct(userInput) && length(userInput)~=1),
            % Invalid input type.
            errID = 'imaq:triggerconfig:invalidParamType';
            error(errID, imaqgate('privateMsgLookup',errID));
            
        elseif isstruct(userInput)
            % TRIGGERCONFIG(OBJ, S)
            validStruct = true;
            usersFields = fieldnames(userInput);
            if ( length(usersFields)~=length(trigfields) )
                validStruct = false;
            else
                for i=1:length(trigfields)
                    if ~isfield(userInput, trigfields{i})
                        validStruct = false;
                    else
                        usersSettings{i} = userInput.(trigfields{i});
                    end
                end
            end
            
            % Check if the MATLAB structure was correct.
            if ~validStruct
                errID = 'imaq:triggerconfig:invalidStruct';
                error(errID, imaqgate('privateMsgLookup',errID));
            end
            
            % Otherwise, just configure the values.
            try
                triggerconfig(uddobj, usersSettings{:})
            catch
                rethrow(lasterror)
            end
            
            % Assign no outputs for this syntax
            return;
        end
        
        % TRIGGERCONFIG(OBJ, TYPE)
        if ~ischar(varargin{1}),
            % Invalid data type.
            errID = 'imaq:triggerconfig:invalidString';
            error(errID, imaqgate('privateMsgLookup',errID));
        end
        userSettings{1} = varargin{1};
        
    case 4,
        % TRIGGERCONFIG(OBJ, TYPE, CONDITION)
        if ~ischar(varargin{1}) || ~ischar(varargin{2}),
            % Invalid data type.
            errID = 'imaq:triggerconfig:invalidString';
            error(errID, imaqgate('privateMsgLookup',errID));
        end
        userSettings{1} = varargin{1};
        userSettings{2} = varargin{2};
        
    case 5,
        % TRIGGERCONFIG(OBJ, TYPE, CONDITION, SOURCE)
        if ~ischar(varargin{1}) || ~ischar(varargin{2}) || ~ischar(varargin{3}),
            % Invalid data type.
            errID = 'imaq:triggerconfig:invalidString';
            error(errID, imaqgate('privateMsgLookup',errID));
        end
        userSettings{1} = varargin{1};
        userSettings{2} = varargin{2};
        userSettings{3} = varargin{3};
        
    otherwise,
        errID = 'imaq:triggerconfig:tooManyInputs';
        error(errID, imaqgate('privateMsgLookup',errID));
end

% Get trigger information.
try
    configurations = triggerinfo(uddobj, userSettings{1});
catch
    rethrow(lasterror);
end

% Perform the configuration.
try
    if length(userSettings)==length(trigfields),
        % TRIGGERCONFIG(OBJ, TYPE, CONDITION, SOURCE)
        triggerconfig(uddobj, userSettings{:});
        
    elseif (nargin==3),        
        % TRIGGERCONFIG(OBJ, TYPE)
        if (length(configurations)==1),
            % Configuration was unique
            configSettings = struct2cell(configurations);
            triggerconfig(uddobj, configSettings{:});
        else
            % Configuration is not unique
            errID = 'imaq:triggerconfig:notUnique';
            error(errID, imaqgate('privateMsgLookup',errID));
        end
        
    else
        % TRIGGERCONFIG(OBJ, TYPE, CONDITION)
        % Need to make sure configuration is unique
        %
        % If there is only 1 configuration with the given 
        % condition, it's unique.
        validConditions = {configurations.(trigfields{2})};
        conditionMatch = strmatch(lower(userSettings{2}), lower(validConditions));
        if length(conditionMatch)==1,
            configMatch = struct2cell(configurations(conditionMatch));
            triggerconfig(uddobj, configMatch{:});
        elseif isempty(conditionMatch)
            errID = 'imaq:triggerconfig:notValid';
            error(errID, imaqgate('privateMsgLookup',errID));
        else
            errID = 'imaq:triggerconfig:notUnique';
            error(errID, imaqgate('privateMsgLookup',errID));
        end
    end
catch
    rethrow(lasterror);
end
