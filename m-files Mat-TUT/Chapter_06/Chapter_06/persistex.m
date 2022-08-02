% This script demonstrates persistent variables
 
% The first function has a variable "count"
fprintf('This is what happens with a "normal" variable:\n')
func1
func1
 
% The second fn has a persistent variable "count"
fprintf('\nThis is what happens with a persistent variable:\n')
func2
func2
