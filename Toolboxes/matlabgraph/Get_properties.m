function props = Get_Properties(varargin)

% get all default properties
props = getappdata(gcf);

% loop through new properties
for i=1:2:length(varargin)
    % check for being a valid option
    if isfield(props,varargin{i})
        % set the property value
        props = setfield(props,varargin{i},varargin{i+1});
    else
        % display error if not found
        error(['Property ' varargin{i} ' not found']);
    end
end