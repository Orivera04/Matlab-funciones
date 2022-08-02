function obj = cgtradeoffnode(varargin)
%CGTRADEOFFNODE Create a new tradeoffnode object
%
%  OBJ = CGTRADEOFFNODE(NAME) constructs a new tradeoff object
%  OBJ = CGTRADEOFFNODE(STRUCT) converts a structure into an object.  This
%  is used during load-time updating of objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $    $Date: 2004/02/09 08:37:18 $ 

DO_HEAP_UPDATE = true;

if nargin==1 && isstruct(varargin{1})
   obj = varargin{1};
   t = obj.cgnode;
   obj = mv_rmfield(obj,'cgnode');
   DO_HEAP_UPDATE = false;
else
    if nargin==0
        DO_HEAP_UPDATE = false;
        t = cgnode;
    else
        t = cgnode('cgtradeoff','');
        t = name(t, varargin{1});
    end

    % construct a new object
    empty_ptr = null(xregpointer, 0);
    obj = struct('Tables', empty_ptr, ...
        'FillExpressions', empty_ptr, ...
        'FillMaskExpressions', empty_ptr, ...
        'ObjectKey', guidarray(1), ...
        'DataKeyTable', cgtradeoffkeytable, ...
        'GraphExpressions', empty_ptr, ...
        'GraphDisplayError', false, ...
        'GraphDisplayConstraints', false, ...
        'GraphDisplaySameY', true, ...
        'GraphHideExpressions', empty_ptr, ...
        'Version', 2);
end

obj = class(obj, 'cgtradeoffnode', t);

if DO_HEAP_UPDATE
   p = xregpointer(obj);
   obj = p.info;
end
