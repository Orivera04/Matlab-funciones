function [ic,D] = state0(D,varargin)
%%DYNAMIC/STATE0         out = state0(D,varargin)
%% nargin==1 returns D.state0 of D
%% nargin==2 sets D.state0 to be input vector
%% ALWAYS checks nStates of simulink model and corrects anomolies

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:07 $

ic = feval(name(D),D,'initcond',varargin{:});
D.state0= ic;
