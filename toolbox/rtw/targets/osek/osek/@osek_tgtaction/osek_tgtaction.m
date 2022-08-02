% File : osek_tgtaction
%
% Abstract :
%   Create the tgtaction object for the osek. All the methods
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
%   $Revision: 1.2.4.1 $
%   $Date: 2004/04/19 01:30:53 $
function varargout = osek_tgtaction(varargin)
    obj.name='osek_tgtaction';
    obj = class(obj,'osek_tgtaction');
    if nargin > 0
      % Invoke a method on the target object
      method = varargin{1};
      if nargin > 1
	args = { varargin{2:end} };
      else
	args = {};
      end
      if ismethod(obj,method)
	if nargout > 0
	  % A return value is requested
	  varargout = { feval(method,obj,args{:}) };
	else
	  % No return value is requested
	  feval(method,obj,args{:});
	  varargout = {};
	end
      else
	% Direct access to subclass method that does not exist in
	% this class. Try to dispatch anyway.
	if nargout > 0
	  % A return value is requested
	  varargout = { feval('dispatch',obj,method,args{:}) };
	else
	  % No return value is requested
	  feval('dispatch',obj,method,args{:});
	end
      end
    else
      varargout = { obj };
    end
    