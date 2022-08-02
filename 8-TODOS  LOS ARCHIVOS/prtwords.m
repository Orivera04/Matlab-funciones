function prtwords(sent)
% prtwords recusively prints the words in a string
% in reverse order
% Format: prtwords(string)

[word, rest] = strtok(sent);
if ~isempty(rest)
   prtwords(rest);
end
disp(word)
end
