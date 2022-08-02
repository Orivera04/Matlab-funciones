function varargout = eval(thing)
%EVAL Evaluate an expression
%
%  ************************************************************************
%  * IMPORTANT:  this function has been deprecated.  It has been replaced *
%  * with the method evaluategrid, or alternatives such as evaluate,      *
%  * evaluatesequential, etc.  Please DO NOT use this method for new work *
%  * and if possible seek to replace uses of it in older work.  This      *
%  * method will be removed at some future point.                         *
%  ************************************************************************
%
%  data = eval(cgexpr)
%
%  An eval method which can hopefully be used by all exprs and should
%  return the result of evaluating an expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:08:30 $



if isa(thing , 'cgvariable')
    varargout{1} = i_eval(thing);
    return;
end

% find data dictionary variables
ddPtrs = getdditems(thing);

% find minimal list with no sym values
Values = cgvarminlist(ddPtrs);

nValues= length(Values);
Values_OLD= info(Values);
if nValues==1
    % make sure Values_OLD is a cell array
    Values_OLD={Values_OLD};
end
% evaluate all the basic inpus
Values_VALUES= pveceval(Values,@i_eval);

if length(Values) > 1
    %Now, do the Nd-gridding thing.
    [Values_NDGRID{1:nValues}] = ndgrid(Values_VALUES{:});
    gridSize = size(squeeze(Values_NDGRID{1}));
    for i = 1:length(Values_NDGRID)
        % make into column vectors
        Values_NDGRID{i}= Values_NDGRID{i}(:);
    end
    
    %Now, set up a bunch of new values.
    Values_NEW= pvecinputeval(Values,'setvalue',Values_NDGRID);
    % assign to heap
    passign(Values,Values_NEW);
    
    flag = 1;
else
    flag = 0;
end

%Now, we should finally be able to eval thing. Do it inside a try catch just in case
varargout = cell(1, nargout);
try
    [varargout{1:nargout}] = i_eval(thing);
catch
    
    %Setting the old value objects back just in case something has gone wrong.
    if flag
        passign(Values,Values_OLD);
    end
    
    %Seeing as something has gone wrong, we'll return NaN as the result.
    for i = 1:nargout
        varargout{i} = NaN;
    end
    return;
end

%Now, we need to set the old value objects back.
if flag
    passign(Values,Values_OLD);
    
    for i = 1:nargout
        %Reshape only those which are doubles and have the same length as the product of the size of Values_NDGRID{1}.
        gridSizeProd = prod(gridSize);
        
        if isa(varargout{i} , 'double') & prod(size(varargout{i})) == gridSizeProd
            varargout{i} = reshape(varargout{i} , gridSize);
        end
    end
end