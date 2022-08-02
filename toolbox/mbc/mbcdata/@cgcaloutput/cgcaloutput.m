function obj = cgcaloutput(node, file)
%CGCALOUTPUT  Object for exporting calibration information
%
%  C = CGCALOUTPUT(nodePtr) constructs an export object for outputting all
%  of the calibration information in nodePtr and it's children.
%
%  C = CGCALOUTPUT(nodePtr,filename) specifies the filename to export to.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:49:24 $



obj = struct('ptrlist', null(xregpointer,0),...
    'filename', '');

if nargin > 0
    % extract all calibration items from the node and sub-nodes.
    p = null(xregpointer, 0);
    q = null(xregpointer, 0);
    
    nodes = node.preorder;
    if ~iscell(nodes)
        nodes = {nodes};
    end
    for n = 1:length(nodes)
        if isa(nodes{n},'cgcontainer');
            p = [p getdata(nodes{n})];
        end
    end
    
    q = pveceval(p, @getptrs);
    q = unique([p, vertcat(q{:})']);
    
    useitem = false(size(q));
    for n = 1:length(q)
        this = q(n).info;
        if isa(this, 'cgexpr') && iscalibratable(this) && ~isempty(this)
            if isa(this,'cgnormaliser')
                parent = get(this,'Flist');
                if ~isempty(parent) & ~parent(1).isa('cglookupone')
                    useitem(n) = true;
                end
            else
                useitem(n) = true;
            end
        end
    end
    obj.ptrlist = q(useitem);
    
    if nargin > 1
        obj.filename = file;
    end
end

obj = class(obj,'cgcaloutput');