function [strings, lChanges, nameMap] = pUpdateToValidNames(strings, nameMap);
%PUPDATETOVALIDNAMES
% 
%  [STRINGS, CHANGES, NAMEMAP] = PUPDATETOVALIDNAMES(STRINGS, NAMEMAP)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 08:20:52 $

IS_CHAR = ischar(strings);
if IS_CHAR
    strings = {strings};
end
% Account for original size
originalSize = size(strings);
% Make vertical 
strings = strings(:);
% Default output
lChanges = false;

if iscell(strings)
    % Need to deblank the input strings
    strings = xregdeblank(strings);
    % Are any in the nameMap
    [lChanges, index] = ismember(strings, nameMap(:, 1));
    % Were any members?
    if any(lChanges)
        % If so replace with the new names
        strings(lChanges) = nameMap(index(lChanges), 2);
    end
    % Did anything get changed?
    lChanges = any(lChanges);
else
    error('mbc:mbctools:InvalidArgument', 'pUpdateToValidNames only works for cell arrays of strings or strings')
end
% Reshape back to original shape
strings = reshape(strings, originalSize);
% Convert back to char
if IS_CHAR
    strings = strings{1};
end
