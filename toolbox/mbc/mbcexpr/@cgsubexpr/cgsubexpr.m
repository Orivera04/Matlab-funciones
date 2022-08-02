function out = cgsubexpr(varargin)
%CGSUBEXPR Constructor for a cgsubExpr class
%
% s=CGSUBEXPR returns an empty subExpr.
% s=CGSUBEXPR(name,left,right) returns a pointer to a cgsubExpr object.
%	Evaluates to left-right
% 	Both arguments must both be pointers or vectors of pointers to cgexpr objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:45 $

if nargin==1 && isstruct(varargin{1})
    out = varargin{1};
    e = out.cgexpr;
    out = rmfield(out, 'cgexpr');
else
    e = cgexpr;
    out = struct('NLeft', 0, ...
        'NRight', 0, ...
        'version', 2);
    if nargin
        if ischar(varargin{1})
            e = setname(e, varargin{1});
        else
            error('mbc:cgsubexpr:InvalidArgument', 'Name must be a string.');
        end
        inputs = [];
        if nargin>1
            %Handle the 2nd argument as the left expression.
            if isa(varargin{2} , 'xregpointer') || isempty(varargin{2})
                inputs = varargin{2}(:)';
                out.NLeft = length(varargin{2});
            else
                error('mbc:cgsubexpr:InvalidArgument', 'Left inputs must be an xregpointer.');
            end
        end
        if nargin>2
            %Handle the 3rd argument as the right expression.
            if isa(varargin{3} , 'xregpointer') || isempty(varargin{3})
                inputs = [inputs, varargin{3}(:)'];
                out.NRight = length(varargin{3});
            else
                error('mbc:cgsubexpr:InvalidArgument', 'Right inputs must be an xregpointer.');
            end     
        end
        e = setinputs(e, inputs);
    end
end
out = class(out , 'cgsubexpr' , e);