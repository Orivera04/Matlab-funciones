function [node, ok, msg] = fill( node, tableptr, featureptr )
%FILL Setup and run the breakpoint fill algorithm
%
%  [NORMNODE, OK, MSG] = FILL( NORMNODE, PTABLE, PFEATURE )
%    PTABLE, pointer to the table this normalizer feeds into
%    PFEATURE, pointer to the feature this normalzer is in
%
%    OK = false -> msg is an error condition
%    OK = true  -> msg is some information
%

%  Copyright 2000-2003 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:33:22 $ 

ok = true;
msg = '';

M = get( node, 'managers');
if isempty( M.InitialisationManager )
    [M.InitialisationManager,OK] = bpfill(tableptr.info, featureptr.info);
end

[M.InitialisationManager,OK] = gui_setup(M.InitialisationManager,'figure',{'expanded',1,'title', 'Breakpoint Fill Options'});
node = set(node, 'managers',M);

if OK
    try
        [tableptr.info,cost, OK, msg] = run(M.InitialisationManager,tableptr.info,[], featureptr.info);
        if ~OK
            msg = sprintf('Cannot fill the breakpoints. %s', msg);
            ok = false;
        else
            msg = sprintf('Filled breakpoints. %s', msg);
            ok = true;
        end
    catch
        msg = sprintf('Unknown error occurred during breakpoint filling. %s', lasterr);
        ok = false;
    end
end
