function [node, ok, msg] = optimize( node, tableptr, featureptr )
%OPTIMIZE Setupo and run the breakpoint optimization algorithm
%
%  [NORMNODE, OK, MSG] = OPTIMIZE( NORMNODE, PTABLE, PFEATURE )
%    PTABLE, pointer to the table this normalizer feeds into
%    PFEATURE, pointer to the feature this normalzer is in
%
%    OK = false -> msg is an error condition
%    OK = true  -> msg is some information
%

%  Copyright 2000-2003 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:33:25 $ 

ok = true;
msg = '';

M = get( node, 'managers');
if isempty( M.OptimisationManager )
    [M.OptimisationManager,OK] = bpopt(tableptr.info, featureptr.info );
end

[M.OptimisationManager,OK] = gui_setup(M.OptimisationManager,'figure',{'expanded',1,'title', 'Breakpoint Optimization Options'});
node = set(node, 'managers',M);

if OK
    try
        [tableptr.info,cost, OK, msg] = run(M.OptimisationManager,tableptr.info,[], featureptr.info);
        if ~OK
            msg = sprintf('Cannot optimize the breakpoints. %s', msg);
            ok = false;
        else
            msg = sprintf('Optimized breakpoints. %s', msg);
            ok = true;
        end
    catch
        msg = sprintf('Unknown error occurred during breakpoint optimization. %s', lasterr);
        ok = false;
    end
end
