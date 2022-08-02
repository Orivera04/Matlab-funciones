function color = setcolorpref(pval)
% SETCOLORPREF generic color options handler.

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.4.4.2 $  $Date: 2004/01/24 09:18:43 $

color = '';

% allow 1x3 numeric
if isnumeric(pval)
    try
        color = sprintf('%02x%02x%02x',pval(1), pval(2),pval(3));
    catch
        color = '';
    end
elseif ischar(pval) % or single chars
    if numel(pval) < 6 && ~isempty(pval)
        switch pval(1)
            case 'r' 
                color = 'FF0000';
            case 'g' 
                color = '00CC00';
            case 'b' 
                color = '0000FF';
            case 'm' 
                color = 'FF00FF';
            case 'c' 
                color = '00FFFF';
            case 'y' 
                color = 'CCCC00';
            case 'w' 
                color = 'FFFFFF';
            case 'k' 
                color = '000000';
        end
    elseif numel(pval) == 6  % or HTML style string
        pval = upper(pval);
        if isempty(regexp(pval,'([^A-F0-9])','once'))
            color = pval;
        end
    end
    
end

if isempty(color)
    color = '000000';
    warning('Bioinfo:BadColorSpec',...
        'Color specifier should be a string or a 1x3 numeric array. Using black.');
end
