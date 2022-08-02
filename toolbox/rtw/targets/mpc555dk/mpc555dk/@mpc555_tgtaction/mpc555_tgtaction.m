% File : mpc555_tgtaction
%
% Abstract :
%   Create the tgtaction object for the mpc555. All the methods
%   on this object will dispatch to the same methods on a 
%   toolchain specific object. The toolchain is retrieved
%   from the TargetPrefs.
%
%   Methods that MAY be implemented on toolchain specific
%   tgtaction objects are
%
%   build   -   build the generated code for the specific toolchain
%   run     -   run the compiled code using the toolchain specific
%               utility
%   debug   -   debug the compiled code using the toolchain specific
%               utility
%   kill    -   kill the toolchain specific utility
%   

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $
%   $Date: 2004/04/19 01:26:31 $
function varargout = mpc555_tgtaction(varargin)
    obj.name='mpc555_tgtaction';
    obj = class(obj,'mpc555_tgtaction');
    if nargin > 0
        % Invoke a method on the target object
        method = varargin{1};
        if nargin > 1
            args = { varargin{2:end} };
        else
            args = {};
        end
        if nargout > 0
            % A return value is requested
            varargout = { feval(method,obj,args{:}) };
        else
            % No return value is requested
            feval(method,obj,args{:});
            varargout = {};
        end
    else
        varargout = { obj };
    end
