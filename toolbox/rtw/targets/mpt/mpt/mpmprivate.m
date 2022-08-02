function varargout = mpmprivate(function_name, varargin)
%MPMPRIVATE is a gateway for internal support functions used by
%           Module Packaging Manager
%
%   VARARGOUT = MPMPRIVATE(FUNCTION_NAME, VARARGIN)
%         This function exists in the mpm directory. It can be called
%         from any directory and used to access functions in the mpm/private
%         directory.
%
%   INPUT:
%         function_name: The mpm private function to call
%         varargin: a list of arguments to pass to the private function
%
%   OUTPUT:
%         varargout: The output arguments of the mpm private function

%   Donn Shull
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.6.4.1 $
%   $Date: 2004/04/15 00:27:23 $

[varargout{1:nargout}] = feval(function_name, varargin{1:end});
