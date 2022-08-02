function AddVariablesToUserdata(system, newNames, varargin)
%AddVariablesToUserdata adds the variables held in the cell array names to the
% block system. The optional arguments in varargin{1}, or varargin{:} will
% be considered as the values to be held in the newly created variables.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:02:32 $

% Ensure that the new names are held in a cell array that is 1xn
if ~iscell(newNames)
   newNames = {newNames};
end

if iscell(varargin{1})
    % If the thrid input parameter is a cell array then
    % assume it contains all the necassary values
    newValues = varargin{1};
else
    % Assume that varargin contains the values
    newValues = varargin;
end
% Ensure vertical names and values cell arrays
newNames  = newNames(:);
newValues = newValues(:);
% Is there the correct amount of data to fill each new variable
if length(newValues) ~= length(newNames)
    error('Values and variables have different lengths')
end

% Really we only want to be dealing with proper udd handles beyond here
hSys = xregConvertSystemToUddHandle(system);

% Get the current userdata from the current system
ud = hSys.userdata;
% Lets check for duplicates in the variables and throw a warning if any are
% found - also throw away the old value of that variable?
if isstruct(ud) & ~isempty(ud)
    names = fieldnames(ud);
    values = struct2cell(ud);    
    [found, location] = ismember(newNames, names);
    if any(found)
        warning('mbc:mbcsimulink:InvalidState', 'Duplicate variables defined in block %s', [hSys.Parent '/' hSys.Name]);
        % Change current values to new values
        values(location) = newValues(found);
        % Remove duplicate names and values
        newNames(found) = [];
        newValues(found) = [];
    end
    % Concatenate the names and values
    newNames  = [names  ; newNames];
    newValues = [values ; newValues];
end
% Sort the names and values
[newNames, index] = sort(newNames);
newValues = newValues(index);
% Update the userdata
hSys.Userdata = cell2struct(newValues, newNames);
% Make sure that the userdata is persistent
hSys.UserdataPersistent = 'on';
% And that the MaskInitialization contains code to load up the variables
% into the block workspace
hSys.MaskInitialization = 'xregmaskinitialization;';
hSys.Mask = 'on';
    