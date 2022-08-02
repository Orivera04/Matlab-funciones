function [xpt, ypt] = entercoords(word);
% entercoords reads in & returns the coordinates of 
%   the specified endpoint of a line segment
% Format: entercoords(word) where word is 'first'
%       or 'second'

% Two different methods are used to customize the 
%   prompt to show the difference
prompt=sprintf('Enter the x coord of the %s endpoint: ', word);
xpt = input(prompt);
 
prompt = sprintf('Enter the y coord of the %s endpoint: ', ...
    word);
ypt = input(prompt);
end
