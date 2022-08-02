function [obj, msg] = concgmodel(sz,varargin)
%concgmodel  CAGE model constraint object
%
%  OBJ=concgmodel(size)  - size = number of factors.
%  OBJ=concgmodel(size,paramlist)  - see setparams for the paramlist
%    specifications.
%
%  concgmodel objects constrain points according to the equation model(X) <= b
% supports the same interfaces as conlinear etc. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:55:40 $


if ~nargin
    sz=4;
end

if isstruct(sz)
    s = sz;
else
    s = struct('modptr', [], ...
        'bound', 0, ...
        'bound_type', 0, ...
        'evaltype', 0, ...
        'version', 2);
end

obj = class(s, 'concgmodel');

if length(varargin)
    [obj,msg]=setparams(obj,varargin{:});
else
    msg={};   
end