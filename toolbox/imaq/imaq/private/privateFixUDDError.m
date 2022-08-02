function privateFixUDDError
%PRIVATEFIXUDDERROR Correct UDD error message.
%
%    PRIVATEFIXUDDERROR parses LASTERR in search of UDD specific tokens. If
%    any are found, they are replaced with the appropriate strings. 
%
%    PRIVATEFIXUDDERROR is useful for correcting UDD property error
%    messages.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:12 $

% Initialize variables.
out = lasterr;
invalidErrID = 'There is no ';
readonlyErrID = 'Changing the';
ambiguousErrID = 'is ambiguous';
enumErrID = 'enumerated value is invalid';
mixClassErrID = 'Objects must all be instances of the same class.';
CR = sprintf('\r');

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
    out = localstrrep(out, uddErrMsg,...
        ['Attempt to modify read-only property: ' quotedProp '.', CR, ...
            'Use IMAQHELP(OBJ, ''' quotedProp(2:end) ') for information.']);
    
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
        ['Invalid property: ' uddErrMsg(startind:endind), '.',...
            CR, 'Type ''imaqhelp'' for information.']);
    
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
        ['Ambiguous property: ' uddErrMsg(startind:endind), '.',...
            CR, 'Type ''imaqhelp'' for information.']);
    
elseif localfindstr(enumErrID, out)
    % Append additional information to the enumerated error message:
    % Ex. The 'log' enumerated value is invalid.
    out = [out, CR, 'Type ''imaqhelp'' for information.'];
    
elseif localfindstr(mixClassErrID, out)
    % Re-word the error.
    out = 'All objects must reference the same image acquisition device.';
end

% Remove the trailing carriage returns from errmsg.
while out(end) == sprintf('\n')
    out = out(1:end-1);
end

lasterr(out);

% *******************************************************************
% findstr which handles possible japanese translation.
function result = localfindstr(str1, out)

result = findstr(sprintf(str1), out);

% *******************************************************************
% strrep which handles possible japanese translation.
function out = localstrrep(out, str1, str2)

out = strrep(out, sprintf(str1), sprintf(str2));
