function Properties = get(UnitObj, varargin)
%GET

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:28 $

%JUNIT/GET  Get properties of a junit object UnitObj.
%
%   Properties = GET(UnitObj) gets properties of a junit object UnitObj.
%
%   Properties = GET(UnitObj, PropertyName) gets a specific property of
%   UnitObj.  The following PropertyName-s are valid: 'Java', 'Name',
%   'Plural', 'Constructor', 'Organisation', 'Version'.  The PropertyName-s
%   'Database' and 'Namespace' return information for the units database.
%
%   See also QUANTITY.

% ---------------------------------------------------------------------------
% Description : Method to get properties of a junit object UnitObj.
% Inputs      : UnitObj    - junit object (junit)
%               PropertyName - property name (string, optional)
% Outputs     : Properties - property value(s) (Java object / string)
% ---------------------------------------------------------------------------

switch nargin,
case 1,
    if(length(UnitObj)==1)
        % Get the properties of a single junit object
        % Properties = UnitObj.Java;
        Properties.Java = UnitObj.Java;
        if ~isvalid(UnitObj)
            Properties.Quantity = {};
            Properties.Name = char(UnitObj);
            Properties.Plural = char(UnitObj);
        else
            if ~isempty(UnitObj.Quantity)
                Properties.Quantity = UnitObj.Quantity;
            else
                Properties.Quantity = quantity(UnitObj);
            end
            Properties.Name = char(UnitObj.Java.getName);
            Properties.Plural = char(UnitObj.Java.getPlural);
        end
        Properties.Difference = UnitObj.Difference;
        Properties.Constructor = UnitObj.Constructor;
        Properties.Organisation = UnitObj.Organisation;
        Properties.Version = UnitObj.Version;
    else
        % Get the properties of multiple unit objects, needs to return an
        % array
        ReshapedUnit = UnitObj(:);
        for ucount = 1:length(UnitObj),
            ThisUnit = ReshapedUnit(ucount);
            Properties(ucount).Java = UnitObj(ucount).Java;
            if ~isvalid(UnitObj(ucount))
                Properties(ucount).Quantity = {};
                Properties(ucount).Name = char(UnitObj(ucount));
                Properties(ucount).Plural = char(UnitObj(ucount));
            else
                if ~isempty(UnitObj(ucount).Quantity)
                    Properties(ucount).Quantity = UnitObj(ucount).Quantity;
                else
                    Properties(ucount).Quantity = quantity(UnitObj(ucount));
                end
                Properties(ucount).Name = char(UnitObj(ucount).Java.getName);
                Properties(ucount).Plural = char(UnitObj(ucount).Java.getPlural);
            end
            Properties(ucount).Difference = UnitObj(ucount).Difference;
            Properties(ucount).Constructor = UnitObj(ucount).Constructor;
            Properties(ucount).Organisation = UnitObj(ucount).Organisation;
            Properties(ucount).Version = UnitObj(ucount).Version;
        end
        Properties = reshape(Properties, size(UnitObj));
    end
otherwise,
    % Try to use extra input as a property name if valid
    Property = i_check(varargin{1}, 'Property');
    switch Property
    case 'Java',
        % Return Constructor
        Properties = UnitObj.Java;
    case 'Difference',
        % Return Difference
        Properties = UnitObj.Difference;
    case 'Quantity',
        % Return Quantity
        Properties = quantity(UnitObj);
    case 'Constructor',
        % Return Constructor
        Properties = UnitObj.Constructor;
    case 'Organisation',
        % Return Organisation
        Properties = UnitObj.Organisation;
    case 'Version',
        % Return numeric Version
        Properties = UnitObj.Version;
    case 'Name',
        % Return unit name
        Properties = char(UnitObj.Java.getName);
    case 'Plural',
        % Return plural
        Properties = char(UnitObj.Java.getPlural);
    case 'Database',
        % Return numeric Version
        Properties = initialise('GET-UNITDB');
    case 'Namespace',
        % Return numeric Version
        Properties = initialise('GET-UNITNS');
    otherwise
        % Invalid property name, return empty
        Properties = [];
    end % if
end % switch

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'Property',
    if ~ischar(in)
        % Property is not a string, use default value
        out = '';
    else
        switch lower(in),
        case 'java',
            % Property name is Java
            out = 'Java';
        case 'quantity',
            % Property name is Quantity
            out = 'Quantity';
        case 'difference',
            % Property name is Difference
            out = 'Difference';
        case 'constructor',
            % Property name is Constructor
            out = 'Constructor';
        case 'organisation',
            % Property name is Organisation
            out = 'Organisation';
        case 'version',
            % Property name is Version
            out = 'Version';
        case 'name',
            % Property name is Name
            out = 'Name';
        case 'plural',
            % Property name is Plural
            out = 'Plural';
        case 'database',
            % Property name is Database
            out = 'Database';
        case 'namespace',
            % Property name is Namespace
            out = 'Namespace';
        otherwise
            % Invalid property name, use default value
            out = '';
        end % switch
    end % if
end % switch