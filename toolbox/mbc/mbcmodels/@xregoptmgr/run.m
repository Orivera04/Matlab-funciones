function [m,cost,OK,varargout]= run(F,ContextObj,x0,varargin);
% xregoptmgr/RUN run the optimisation routine
%
% [m,cost,OK,varargout]= run(ContextObj,F,x0,varargin)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:56 $

% [m,cost,OK,varargout]= RunOpt(ContextObj,x0,foptions,varargin)
[m,cost,OK,varargout{1:nargout-3}]= feval(F.RunFcn,ContextObj,F,x0,varargin{:});
