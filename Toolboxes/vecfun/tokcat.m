function str=tokcat(tok)
%TOKCAT  Concatenate tokens to string.
%   STR = TOKCAT(TOK), concatenates the tokens
%   in the token list TOK into a string STR.
%
%   See also SCANNER.

% Copyright (c) 2001-08-19, B. Rasmus Anthin.

str='';
for i=1:size(tok,1)
   str=[str deblank(tok(i,:))];
end