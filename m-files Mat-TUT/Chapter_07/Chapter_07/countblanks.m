function num = countblanks(phrase)
% countblanks returns the # of blanks in a trimmed string
% Format: countblanks(string)

num = length(strfind(strtrim(phrase), ' '));
end