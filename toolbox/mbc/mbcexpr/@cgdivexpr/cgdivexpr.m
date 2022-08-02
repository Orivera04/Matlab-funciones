function div = cgdivexpr(varargin)
%CGDIVEXPR Division Expression object constructor
%
%   divexpression = cgdivexpr
%		Returns an empty divExpr object
%   divExprPtr = cgdivexpr(name , top_exprPtr , bottom_exprPtr)
%		Returns a xregpointer to a cgdivExpr object
%     Top and bottom arguments must both be xregpointers to expressions.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:35 $



if nargin==1 && isstruct(varargin{1})
    div = varargin{1};
    e = div.cgexpr;
    div = rmfield(div, 'cgexpr');
else
    e = cgexpr;
    div = struct('NTop', 0, ...
        'NBottom', 0, ...
        'version', 2);
    if nargin
        if ischar(varargin{1})
            e = setname(e, varargin{1});
        else
            error('mbc:cgdivexpr:InvalidArgument', 'Name must be a string.');
        end
        inputs = [];
        if nargin>1
            %Handle the 2nd argument as the top expression.
            if isa(varargin{2} , 'xregpointer') || isempty(varargin{2})
                inputs = varargin{2}(:)';
                div.NTop = length(varargin{2});
            else
                error('mbc:cgdivexpr:InvalidArgument', 'Top inputs must be an xregpointer.');
            end
        end
        if nargin>2
            %Handle the 3rd argument as the top expression.
            if isa(varargin{3} , 'xregpointer') || isempty(varargin{3})
                inputs = [inputs, varargin{3}(:)'];
                div.NBottom = length(varargin{3});
            else
                error('mbc:cgdivexpr:InvalidArgument', 'Bottom inputs must be an xregpointer.');
            end     
        end
        e = setinputs(e, inputs);
    end
end
div = class(div , 'cgdivexpr' , e);