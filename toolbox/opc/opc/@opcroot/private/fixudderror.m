function fixudderror(obj)
%FIXUDDERROR Correct UDD error message.
%   FIXUDDERROR parses LASTERR in search of UDD specific tokens. If
%   any are found, they are replaced with the appropriate strings. 
%
%   FIXUDDERROR is useful for correcting UDD property error
%   messages.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 22:07:01 $

% Initialize variables.
className = class(obj);
[out, lastID] = lasterr;
invalidErrID = 'There is no ';
readonlyErrID = 'Changing the';
ambiguousErrID = 'is ambiguous';
enumErrID = 'enumerated value is invalid';
callbackErrID = 'function handle';
invalidpvErrID = 'Invalid parameter/value pair';
arrayobjectErrID = 'Only one object may be passed';
CR = sprintf('\n');

if localfindstr(readonlyErrID, out)
    % Need to correct read-only error message:
    % Ex. Changing the 'Logging' property of [PackageName].[ClassName] is not allowed.
    
    % Extract the UDD error sentence.
    startind = localfindstr(readonlyErrID, out);
    endind = localfindstr('is not allowed.', out) + 14;
    uddErrMsg = out(startind:endind);
    
    % Determine the invalid property in the sentence.
    startind = localfindstr('the ''',uddErrMsg) + 4;
    endind = localfindstr(''' property',uddErrMsg);
    quotedProp = uddErrMsg(startind:endind);
    
    % Replace with new error message.
    % First make up a string
    out = localstrrep(out, uddErrMsg,...
        ['The property ' quotedProp ' is read-only.']);
    
    lastID = sprintf('opc:%s:readonlyprop', evalin('caller','mfilename'));
elseif localfindstr(invalidErrID, out)
    % Need to correct invalid property error message:
    % Ex. There is no 'blahblah' property in the 'UDDNIClass' class.
    
    % Extract the UDD error sentence.
    startind = localfindstr(invalidErrID, out);
    endind = localfindstr(''' class.', out) + 7;
    uddErrMsg = out(startind:endind);
    
    % Determine the invalid property in the sentence.
    startind = localfindstr('no ''',uddErrMsg) + 3;
    endind = localfindstr(''' property',uddErrMsg);
    
    % Replace with new error message.
    out = localstrrep(out, uddErrMsg,...
        ['Unknown property: ' uddErrMsg(startind:endind), '.']);
    lastID = sprintf('opc:%s:unknownprop', evalin('caller','mfilename'));
elseif localfindstr(ambiguousErrID, out)
    % Need to correct the ambiguous error message:
    % Ex. The 'log' property name is ambiguous in the 'UDDNIClass' class.
    
    % Extract the UDD error sentence.
    startind = localfindstr('The', out);
    endind = localfindstr(''' class.', out) + 7;
    uddErrMsg = out(startind:endind);
    
    % Determine the invalid property in the sentence.
    startind = localfindstr('The ''', uddErrMsg) + 4;
    endind = localfindstr(''' property', uddErrMsg);
    
    % Replace with new error message.
    out = localstrrep(out, uddErrMsg,...
        ['Ambiguous property: ' uddErrMsg(startind:endind), '.']);
    
    lastID = sprintf('opc:%s:ambiguousprop', evalin('caller','mfilename'));
elseif localfindstr(enumErrID, out)
    % Append additional information to the enumerated error message:
    % Ex. The 'log' enumerated value is invalid.
    
    % PROBLEM: This doesn't provide the property, only the bad value!
    %       GECK this as a really big problem!!!!!
    
%     % Extract the UDD error sentence.
%     startind = localfindstr('The', out);
%     endind = localfindstr('is invalid.', out) + 10;
%     uddErrMsg = out(startind:endind);
%     
%     % Determine the invalid property in the sentence.
%     startind = localfindstr('The ''', uddErrMsg) + 4;
%     endind = localfindstr(''' enumerated', uddErrMsg);
%     propName = uddErrMsg(startind:endind);
%     
%     % Replace with new error message.
%     out = localstrrep(out, uddErrMsg,...
%         ['Bad value for ' className ' property: ', propName, '.',...
%             CR, 'Type ''opchelp ', className, '.', propName, ''' for information.']);
    lastID = sprintf('opc:%s:badvalue', evalin('caller','mfilename'));
elseif localfindstr(callbackErrID, out)
    % Just trapping to set the error ID
    lastID = sprintf('opc:%s:invalidcallback', evalin('caller','mfilename'));
elseif localfindstr(invalidpvErrID, out)
    % Trapping to set the error ID, since we have no other information!
    lastID = sprintf('opc:%s:invalidpvpairs', evalin('caller','mfilename'));
elseif localfindstr(arrayobjectErrID, out)
    lastID = sprintf('opc:%s:scalarobj', evalin('caller','mfilename'));
end

% Remove the trailing carriage returns from errmsg.
while out(end) == sprintf('\n')
    out = out(1:end-1);
end
lasterr(out, lastID);

% *******************************************************************
% findstr which handles possible japanese translation.
function result = localfindstr(str1, out)

result = findstr(sprintf(str1), out);

% *******************************************************************
% strrep which handles possible japanese translation.
function out = localstrrep(out, str1, str2)

out = strrep(out, sprintf(str1), sprintf(str2));
