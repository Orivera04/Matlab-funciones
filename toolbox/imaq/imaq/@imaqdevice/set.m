function out = set(obj, varargin)
%SET Configure or display image acquisition object properties.
% 
%    SET(OBJ) displays property names and any enumerated values for all 
%    configurable properties of image acquisition object OBJ. OBJ must  
%    be a single image acquisition object.
%
%    PROP_STRUCT = SET(OBJ) returns the property names and any 
%    enumerated values for all configurable properties of image acquisition
%    object OBJ. OBJ must be a single image acquisition object. The return
%    value, PROP_STRUCT, is a structure whose field names are the property
%    names of OBJ. The value of each field is a cell array containing the
%    enumerated values for the property or an empty cell array if the 
%    property does not have a finite set of enumerated values.
%
%    SET(OBJ,'PropertyName') displays the enumerated values for the 
%    specified property, PropertyName, of image acquisition object OBJ. 
%    OBJ must be a single image acquisition object.
%
%    PROP_CELL = SET(OBJ,'PropertyName') returns the enumerated values
%    for the specified property, PropertyName, of image acquisition 
%    object OBJ. OBJ must be a single image acquisition object. The 
%    returned array, PROP_CELL, is a cell array of strings containing
%    the enumerated values for the property or an empty cell 
%    array if the property does not have a finite set of enumerated 
%    values.
%
%    SET(OBJ,'PropertyName',PropertyValue,...) configures the property, 
%    PropertyName, to the specified value, PropertyValue, for image 
%    acquisition object OBJ. You can specify multiple property 
%    name/property value pairs in a single statement. OBJ can be a 
%    single image acquisition object or a vector of image acquisition
%    objects, in which case SET configures the property values for all
%    the image acquisition objects specified.
%
%    SET(OBJ,S) configures the properties of OBJ, with the values
%    specified in S, where S is a structure whose field names are
%    object property names.
%
%    SET(OBJ,PN,PV) configures the properties specified in the cell array  
%    of strings, PN, to the corresponding values in the cell array
%    PV, for the image acquisition object OBJ. PN must be a vector. 
%    If OBJ is an array of image acquisition objects, PV can be an 
%    M-by-N cell array, where M is equal to the length of the image
%    acquisition object array and N is equal to the length of PN. In this
%    case, each image acquisition object is updated with a different set
%    of values for the list of property names contained in PN.
%
%    Parameter/value string pairs, structures, and parameter/value cell
%    array pairs may be used in the same call to SET.
%
%    Example:
%       obj = videoinput('matrox', 1);
%       set(obj, 'FramesPerTrigger', 15, 'LoggingMode', 'disk');
%       set(obj, {'TimerFcn', 'TimerPeriod'}, {@imaqcallback, 25});
%       set(obj, 'Name', 'MyObject');
%       set(obj, 'SelectedSourceName')
%
%    See also IMAQDEVICE/GET, IMAQDEVICE/PROPINFO, IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:31 $

% Call private SET function.
nin = nargin;
nout = nargout;
[result, errStruct] = imaqgate('privateSet', obj, varargin, nin, nout);

% Try erroring before returning.
%
% Note: Don't use RETHROW unless you don't mind that the
%       "??? Error using ==> imaqdevice/XXX" line is not displayed.
if ~isempty(errStruct.identifier),
    % Identifier exists. There must be an error message as well.
    error(errStruct.identifier, errStruct.message);
elseif ~isempty(errStruct.message),
    % Message exists, but no identifier? Must be a UDD error.
    error(errStruct.message);
end

% Assign the output for the appropriate syntax.
if (nout>0)
    if (nin==1) || (nin==2),
        %   out = set(obj)
        %   out = set(obj, Property)
        out = result;
    end
end