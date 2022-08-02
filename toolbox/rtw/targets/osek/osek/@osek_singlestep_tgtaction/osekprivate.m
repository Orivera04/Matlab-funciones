%OSEKPRIVATE is a gateway for internal support functions used by 
%           osek.
%   VARARGOUT = OSEKPRIVATE('FUNCTION_NAME', VARARGIN) 
%   
%   

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision $

function varargout = osekprivate(obj, function_name, varargin)
  
  if nargin == 2
    if nargout > 0
      [varargout{1:nargout}] = { feval(function_name) };
    else
      feval(function_name);
    end
  else
    if nargout > 0
      [varargout{1:nargout}] = { feval(function_name,varargin{1:end}) };
    else
      feval(method,t_obj,varargin{:});
    end
  end
