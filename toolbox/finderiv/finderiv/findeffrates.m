function Rates = findeffrates(Tree, StartTime, EndTime)
% FINDEFFRATES Calculate the effective rate between two tree levels.
%
%   This is a private function that is not meant to be called directly
%   by the user.
%
% Inputs:
% 	Tree		- Tree containing rates
%   StarTime	- Scalar indicating the StartTime.
%   EndTime     - Scalar indicating the EndTime.
%                   
% Outputs:
%  	Rates       - 1 x NStates vector holding the effective rates
%                   between StartTime and EndTime. NStates is the 
%                   number of states at the tree level falling in 
%                   EndTime.
%

%   Author(s): M. Reyes-Kattar, 05/01/2000
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.4 $  $Date: 2002/04/14 16:38:22 $

%-----------------------------------------------------------------
% Checking inputs
%-----------------------------------------------------------------

if (nargin < 3),
  error('You must pass at least three input arguments')
end

if(length(StartTime) ~=1 | length(EndTime) ~=1)
    error('StartTime and EndTime must be scalars')
end

if isafin(Tree,'HJMFwdTree')
    
	Rates = hjmfindeffrates(Tree, StartTime, EndTime);
    
elseif isafin(Tree,'BDTFwdTree')
    
	Rates = bdtfindeffrates(Tree, StartTime, EndTime);
    
else
    
	error('The first argument must be an HJM tree or a BDT tree');
    
end
