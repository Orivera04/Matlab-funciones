%FUNCTION Function M-files.
%	New functions may be added to MATLAB's vocabulary if they
% 	are expressed in terms of other existing functions. The 
% 	commands and functions that comprise the new function must
% 	be put in a file whose name defines the name of the new 
% 	function, with a filename extension of '.m'. At the top of
%	the file must be a line that contains the syntax definition
%	for the new function. For example, the existence of a file 
%	on disk called STAT.M with:
% 
% 	        function [mean,stdev] = stat(x)
% 	        n = length(x);
% 	        mean = sum(x) / n;
% 	        stdev = sqrt(sum((x - mean).^2)/n);
% 
% 	defines a new function called STAT that calculates the 
% 	mean and standard deviation of a vector. The variables
% 	within the body of the function are all local variables.
% 	See SCRIPT for procedures that work globally on the work-
% 	space. 
%
%	See also ECHO, SCRIPT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
