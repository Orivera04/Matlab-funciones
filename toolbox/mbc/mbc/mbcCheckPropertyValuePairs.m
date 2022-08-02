function values = mbcCheckPropertyValuePairs(validProps, validValues, defaultValues, varargin)
%MBCCHECKPROPERTYVALUEPAIRS generic interface to using property value pairs
%
%  VALUES = MBCCHECKPROPERTYVALUEPAIRS(VALID_PROPS, VALID_VALUES, ...
%    DEFAULT_VALUES, PROP-VALUE PAIRS)
%
%  VALID_PROPS is a cell array of valid property names. Even if there is
%  only one valid property name it MUST still be a cell array. The order in
%  which properties are listed is the order in which the values are sent
%  out.
%
%  VALID_VALUES is a cell array of the same length as VALID_PROPS. The
%  interpretation of a VALID_VALUE is dependent on the class of the value.
%  If it is a string then an isa type comparision is carried out. If it is
%  a double array or cell array of strings then an ismember comparision is
%  carried out.
%
%  DEFAULT_VALUES are the values to be assigned where a particular value is
%  not included in the property-value pairs. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:48:35 $

% Setup the default output values
values = defaultValues;

% Iterate over the property value pairs
for i = 1:2:length(varargin)
    % Get this particular property and value
    thisProp = varargin{i};
    thisValue = varargin{i+1};
    % Check that the property is a string
    if ~ischar(thisProp)
        error('mbc:propertyvaluecheck:InvalidPropertyName', 'Property names must be a string');
    end
    % Try and find the property in the valid properties list
    index = find(strcmpi(thisProp, validProps));
    % Did we find it?
    if isempty(index)
        error('mbc:propertyvaluecheck:InvalidPropertyName', 'Property %s is not a valid property name', thisProp);
    end
    % What are the validValues
    theValidValues = validValues{index};
    % We found it - what sort of check are we doing
    switch class(theValidValues)
        % An ismember comparision with possible double values
        case 'double'
            % Check that thisValue is double
            if ~isdouble(thisValue)
                error('mbc:propertyvaluecheck:InvalidPropertyValue', ...
                    'Property %s is specified as being of type double', thisProp);
            end
            % Check that thisValue is a member of the validValues
            if ~ismember(thisValue, theValidValues)
                error('mbc:propertyvaluecheck:InvalidPropertyValue', ...
                    'Property %s has been specified with a value outside the allowed range', thisProp);
            end
        % Expecting a cell array of strings to check against    
        case 'cell'
            % Check that thisValue is a string
            if ~ischar(thisValue)
                error('mbc:propertyvaluecheck:InvalidPropertyValue', ...
                    'Property %s is specified as being of type string', thisProp);
            end
            % Check that thisValue is a member of the validValues
            if ~ismember(thisValue, theValidValues)
                error('mbc:propertyvaluecheck:InvalidPropertyValue', ...
                    'Property %s has been specified with a value outside the allowed range', thisProp);
            end
        % Case check the property only
        case 'char'
            if ~isa(thisValue, theValidValues)
                error('mbc:propertyvaluecheck:InvalidPropertyValue', ...
                    'Property %s is specified as being of type %s', thisProp, theValidValues);
            end
        otherwise
            
    end
    % OK - copy to the output
    values{index} = thisValue;    
end