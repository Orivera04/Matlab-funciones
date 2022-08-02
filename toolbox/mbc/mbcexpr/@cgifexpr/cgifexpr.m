function out=cgifexpr(varargin)
%CGIFEXPR Constructor for the cgifExpr class
%
% I = CGIFEXPR returns an empty cgifExpr
% I = CGIFEXPR(name,A,B,C,D) returns an cgifExpr object:
%		if A<B then out=C else out=D
%		Where A,B,C,D are xregpointers to expressions
%  e.g. cgifexpr(name,A,B,A,B) returns the lesser of A and B at every point

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:06 $

% Ifexpr holds inputs in the parent class inputs field.  There are always 4
% inputs which are held in the order ["left", "right", "out1", "out2"].

e = cgexpr;
e = setinputs(e, null(xregpointer, 1, 4));
ifexp = struct('version', 2);

if nargin==1
    ifexp = varargin{1};
    e = ifexp.cgexpr;
    ifexp = rmfield(ifexp, 'cgexpr');
elseif (nargin==5)
    e = setname(e , varargin{1});
    inputs = [varargin{2:5}];
    if isa(inputs, 'xregpointer');
        e = setinputs(e, inputs);
    else
        error('mbc:cgifexpr:InvalidPropertyValue', 'Inputs to expression must be xregpointers.');
    end
elseif nargin>0
    error('mbc:cgifexpr:InvalidArgument', 'Wrong number of input arguments to constructor.');
end

out = class(ifexp , 'cgifexpr' , e);