function cobj = cgoptcsol(varargin)
%CGOPTCSOL Constructor for the custom optimisation solution class
%
%  COBJ = CGOPTCSOL(IN)
%  
% Add some help  here
% This function currently performs no error checking

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:52:23 $ 

if nargin > 0
   error('CGOPTCSOL::This function creates an empty class');
end

% Empty structure
s.solutionNo = [];

% Current version 
s.version  = 1;

cobj = class(s, 'cgoptcsol'); 

