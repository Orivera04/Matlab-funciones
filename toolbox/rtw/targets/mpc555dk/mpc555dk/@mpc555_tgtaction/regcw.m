function regcw(obj,varargin)
% regcw(this, varargin )
%
% Abstract : 
%  See CodeWarrior implementation.
%
% Arguments :
%  See CodeWarrior implementation
%

% Copyright 2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ 
% $Date: 2004/03/15 22:23:43 $

    % Return the toolchain specific object
    dispatch(obj,'regcw',varargin{:});
