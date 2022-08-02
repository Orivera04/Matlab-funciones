function [m,OK,varargout] = runfit(m,X,Y,varargin)
%RUNFIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:53:01 $

if isa(m.FitAlgorithm,'xregoptmgr')
	% optim Manager
	% 
	% pass current parameters as initial conditions
	x0= double(m);
	[m,cost,OK,varargout{1:nargout-2}]= run(m.FitAlgorithm,m,x0,X,Y,varargin{:});
else
	% old format
	% function as char or function handle
	[m,OK,varargout{1:nargout-2}]= feval(m.FitAlgorithm,m,X,Y,varargin{:});
end

