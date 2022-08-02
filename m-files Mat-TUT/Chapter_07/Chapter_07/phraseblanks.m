% This script creates a column vector of phrases
% It loops to call a function to count the number
%  of blanks in each one and prints that 
 
phrasemat = char('Hello and how are you?', ...
  'Hi there everyone!', 'How is it going?', 'Whazzup?')
[r c] = size(phrasemat);
 
for i = 1:r
    % Pass each row (each string) to countblanks function
    howmany = countblanks(phrasemat(i,:));
    fprintf('Phrase %d had %d blanks\n',i,howmany)
end
