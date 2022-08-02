function varargout = HTMLattic(method, varargin)
% similar to rtwattic, it's a handy data attic to store search and config
% wizard data
% HTMLattic('AtticData', field, value) to set value
% HTMLattic('AtticData', field)        to get value
% HTMLattic('AtticData', '')           to get entire data as struct

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:15 $

% prevent USERDATA from being cleared
mlock
persistent USERDATA

[USERDATA, varargout{1:nargout}] = feval(method, USERDATA, varargin{1:end});


% Function: clean =============================================================
% Abstract:
%
function userdata = clean(userdata)
clear userdata;
userdata = '';

function userdata = init(userdata, model)
userdata.model = model;

%---------------------------------------------------------------------%
% Generic AtticData access function
%---------------------------------------------------------------------%
function [StateVar, returnVal] = AtticData(StateVar, varargin)
%
% function to create and return local state
%
% call as AtticData(USERDATA, varargin)
%
  
  returnVal = [];
  switch (nargin)
   case (2)
    if isempty(varargin{1})
      % Return entire state when arg1 is void.
      returnVal = StateVar;
    else
      if isfield(StateVar, varargin{1})
	returnVal = eval(['StateVar.' varargin{1}]);
      end
    end
   case (3)
    if isstr(varargin{1})
      eval(['StateVar.' varargin{1} ' =  varargin{2};']);
    end
  end
  return;
