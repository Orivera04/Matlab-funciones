function out = get(obj, varargin)
%GET Get image acquisition object properties.
%
%    GET(OBJ) displays all property names and their current values for
%    image acquisition object OBJ.
%
%    V = GET(OBJ) returns a structure, V, in which each field name is 
%    the name of a property of OBJ and each field contains the value of 
%    that property.
%
%    V = GET(OBJ,'Property') returns the value, V, of the specified 
%    property, Property, for image acquisition object OBJ. 
%
%    If Property is replaced by a 1-by-N or N-by-1 cell array of strings 
%    containing property names, GET returns a 1-by-N cell array
%    of values. If OBJ is a vector of image acquisition objects, V is an
%    M-by-N cell array of property values where M is equal to the length
%    of OBJ and N is equal to the number of properties specified.
%
%    Example:
%       obj = videoinput('matrox', 1);
%       get(obj, {'FramesPerTrigger','FramesGrabbed'})
%       out = get(obj, 'LoggingMode')
%       get(obj)
%
%    See also IMAQDEVICE/SET, IMAQDEVICE/PROPINFO, IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:13 $

% Call private GET function.
nin = nargin;
nout = nargout;
[output, errStruct] = imaqgate('privateGet', obj, varargin, nin, nout);

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

% Assign the output for the case of:
%
%   A) out = get(obj);
%   B) out = get(obj, PropertyInput)
%   C) get(obj, PropertyInput)
syntaxA = (nout==1) & (nin==1);
syntaxBC = nin==2;
if (syntaxA || syntaxBC)
    out = output;
end
