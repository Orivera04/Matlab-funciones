function y = mysum(varargin)
%MYSUM Add all input values and return result.
%   Y = MYSUM(VARARGIN) adds all the values supplied to
%   varargin and returns the result.  
%   This file is used as an example for the MATLAB 
%   Excel Builder product.

%   Copyright (c) 2001 The MathWorks, Inc. 
%   $Revision: 1.1 $     $Date: 2001/11/27 20:41:37 $

y = sum([varargin{:}])
