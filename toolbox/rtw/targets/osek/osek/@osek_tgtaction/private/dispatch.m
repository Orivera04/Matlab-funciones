% File : dispatch(obj,method,varargin)
%
% Abstract :
%   Dispatch the method to the toolchain specific
%   tgtaction object and pass all other arguments
%   along.
%
%   This will throw a error if there is no build function
%   for the current toolchain

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $
%   $Date: 2004/04/19 01:30:54 $
function varargout = dispatch(obj,method,varargin)
    t_obj = get_tgtaction_object(obj);
    if ismethod(t_obj,method)
        if nargout > 0
            varargout = { feval(method,t_obj,varargin{:}) };
        else
            feval(method,t_obj,varargin{:});
        end
    else
        error(['"' method  '" target action is not available for toolchain ' ...
            get_current_toolchain ]);
        varargout = {};
    end
