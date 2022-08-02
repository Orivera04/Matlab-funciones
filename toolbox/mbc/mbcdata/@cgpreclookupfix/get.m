function LOOKUPFIXPRECProperty = get(LOOKUPFIXPREC, varargin)
%GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:03 $

%CGPRECLOOKUPFIX/GET  Get properties of a cgpreclookupfix object.
%
%   LOOKUPFIXPRECProperty = GET(LOOKUPFIXPREC, Property) returns the
%   specified property Property of the cgpreclookupfix object
%   LOOKUPFIXPREC.
%
%   LOOKUPFIXPRECProperty = GET(LOOKUPFIXPREC) returns all available
%   properties of the cgpreclookupfix object.
%
%   See also  CGPRECLOOKUPFIX

% ---------------------------------------------------------------------------
% Description : Method to get properties of a cgpreclookupfix object
%               LOOKUPFIXPREC.
% Inputs      : LOOKUPFIXPREC         - cgpreclookupfix object specifying
%                                       table data, interpolation method and
%                                       the admissible physical range
% Opt inputs  : Property              - cgpreclookupfix object property
%                                       name (char)
% Outputs     : LOOKUPFIXPRECProperty - property value (cell/dbl)
% ---------------------------------------------------------------------------

switch nargin,
case 1,
    % Return all available properties in a cell array
    LOOKUPFIXPRECProperty               = get(LOOKUPFIXPREC.cgprecfix);
    LOOKUPFIXPRECProperty.TablePhysData = LOOKUPFIXPREC.TablePhysData;
    LOOKUPFIXPRECProperty.TableHWData   = LOOKUPFIXPREC.TableHWData;
    LOOKUPFIXPRECProperty.PhysRange     = ...
        [max(min(LOOKUPFIXPREC.PhysRange), min(LOOKUPFIXPREC.TablePhysData)), ...
         min(max(LOOKUPFIXPREC.PhysRange), max(LOOKUPFIXPREC.TablePhysData))];
otherwise,
    % Try to use extra input as a property name if valid
    Property = i_check(varargin{1}, 'Property');
    switch Property
    case 'TablePhysData',
        % Return TablePhysData
        LOOKUPFIXPRECProperty = LOOKUPFIXPREC.TablePhysData;
    case 'TableHWData',
        % Return TableHWData
        LOOKUPFIXPRECProperty = LOOKUPFIXPREC.TableHWData;
    case 'PhysRange',
        % Return Range, which may be limited explicitly by PhysRange or
        % implicitly by TablePhysData (since there is no extrapolation)
        LOOKUPFIXPRECProperty = ...
        [max(min(LOOKUPFIXPREC.PhysRange), min(LOOKUPFIXPREC.TablePhysData)), ...
         min(max(LOOKUPFIXPREC.PhysRange), max(LOOKUPFIXPREC.TablePhysData))];
    otherwise
        if ~isempty(get(LOOKUPFIXPREC.cgprecfix, varargin{1}))
            % Property was defined in the parent, get data from there
            LOOKUPFIXPRECProperty = ...
                get(LOOKUPFIXPREC.cgprecfix, varargin{1});
        else
            % Invalid property name, return empty
            LOOKUPFIXPRECProperty = [];
        end % if
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
        case 'tablephysdata',
            % Property name is TablePhysData
            out = 'TablePhysData';
        case 'tablehwdata',
            % Property name is TableHWData
            out = 'TableHWData';
        case 'physrange',
            % Property name is PhysRange
            out = 'PhysRange';
        otherwise
            % Invalid property name, use default value
            out = '';
        end % switch
    end % if
end % switch