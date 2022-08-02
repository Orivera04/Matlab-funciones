function out = cgvarminlist(var)
% out = cgvarminlist(var)
% Return a minimum equivalent list of variables, removing any redundancy caused by
% repeated pointers or cgsymvalues

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:39:47 $
out = [];
if ~isempty(var)
    var = var(:)';
    var = unique(var);
    isSYM= pveceval(var,@issymvalue);
    ind= find([isSYM{:}]);
    if isempty(ind)
        % no formulae
        out = var;
    else
        % non formulae variables
        out = var(setdiff(1:length(var),ind));
        
        % inputs to 
        prhs= pveceval(var(ind),@getrhsptrs);
        out = [out prhs{:}];
        out = unique(out);
    end
end
