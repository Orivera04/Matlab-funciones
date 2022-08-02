function assignHere(varargin)
%ASSIGNHERE Creates a variable in the current workspace.
%   ASSIGNHERE is a little trick to get ASSIGNIN to assign a
%   variable in the current workspace.
%
%   Example:  assignHere('test', [1 2 3]);
%   If this were attempted within a function file, it would not be
%   possible to assign in the current workspace, only the caller or
%   base.

%    Doug Hull <hull@mathworks.com>     3/11/2003
%    Copyright 1984-2003 The MathWorks, Inc.
%    This function is not supported by The MathWorks, Inc.
%    It is provided 'as is' without any guarantee of
%    accuracy or functionality.

assignin('caller', varargin{:})