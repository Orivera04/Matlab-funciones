function [ok, errmsg] = FillTable(op,tptr,out_i,index)
% CGOPPOINT/FILLTABLE
%  FillTable(op,tptr,factor) fills table tptr, using given factor.
%              All enabled rules are applied.
%  FillTable(op,tptr,factor,index) uses only the data points given
%               by index.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.4 $  $Date: 2004/02/09 06:51:14 $

ok = 0; errmsg = [];
if nargin<4
    index = Apply(op.rules,op.data);
end
if ~isnumeric(out_i) | length(out_i)~=1 | ~ismember(out_i,1:length(op.ptrlist))
    errmsg = 'cgoppoint::filltable: bad index into factors.';
    return;
end
% if op.factor_type(out_i)~=2
%     errmsg = 'cgoppoint::filltable: fill factor is not an output.';
%     return;
% end

axesptrs = tptr.get('axesptrs');
axes = tptr.get('axes');

switch length(axesptrs)
case 2
    % 2D table
    % index contains selected dataset points
    x_i = find(op.ptrlist==axesptrs(1));
    y_i = find(op.ptrlist==axesptrs(2));
    if isempty(x_i) | isempty(y_i)
        errmsg = ['cgoppoint::filltable: cannot fill this table from dataset.',...
                'Inputs required: ' axesptrs(1).getname ', ' axesptrs(2).getname '.'];
        return;
    end
    
    % Take the first pointer in the axis pointer variables - this avoids
    % problems with links...
    filldata = op.data(index,[x_i(1) y_i(1) out_i]);
    
    % Prepare big matrix
    [xpts,xi,xj] = unique([axes{1} filldata(:,1)']);
    [ypts,yi,yj] = unique([axes{2} filldata(:,2)']);
    valM = repmat(0,length(ypts),length(xpts));
    mask = logical(valM);
    % Fill matrix with data points
    mindex = yj(length(axes{2})+1:end) + (size(valM,1)*(xj(length(axes{1})+1:end) - 1));
    valM(mindex) = filldata(:,3);
    mask(mindex) = true;
    
    % Do the extrapolation
    valM = eval(cgmathsobject,'extrapolate_values_RBF',valM,mask,xpts,ypts);
    
    % retrieve table values
    tabval = valM(yj(1:length(axes{2})),xj(1:length(axes{1})));
    
    % Set new values
    fact = get(op,out_i,'factors');
    info = ['Values filled from data set ' op.name ', factor ' fact];
    tptr.info = tptr.set('values',{tabval , info});
case 1
    axes = {axes};
    x_i = find(op.ptrlist==axesptrs(1));
    if isempty(x_i) 
        errmsg = ['cgoppoint::filltable: cannot fill this table from dataset.',...
                'Inputs required: ' axesptrs(1).getname '.'];
        return;
    end
    
    % Take the first pointer in the axis pointer variables - this avoids
    % problems with links...
    filldata = op.data(index,[x_i(1) out_i]);    
    
    [xpts, xi] = unique(filldata(:,1)');
    if length(xi) < 2
       errmsg = ['Data set only has one unique point for ', axesptrs(1).getname, ...
               '. Cannot fill this table from the data set'];
       return;
   end
    ypts = filldata(xi, 2);
    % Do the extrapolation
    tabvalues = tptr.get('values');
    if size(tabvalues, 2)  > 1
        xtabpts = axes{1}(:)';
    else
        xtabpts = axes{1}(:);
    end
    tabval = eval(cgmathsobject,'extinterp1',xpts,ypts, xtabpts);
    % Set new values
    fact = get(op,out_i,'factors');
    info = ['Values filled from data set ' op.name ', factor ' fact];
    tptr.info = tptr.set('values',{tabval , info});
otherwise
    errmsg = 'table has invalid number of pointers.';
    return;
end

% Set the OK flag
if isempty(errmsg)
    ok = 1;
end

