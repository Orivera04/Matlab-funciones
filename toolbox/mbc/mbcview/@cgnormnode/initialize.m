function [node, ok, msg] = initialize( node, tableptr )
%INITIALIZE Setup and run the breakpoint initialization algorithm
%
%  [NORMNODE, OK, MSG] = INITIALIZE( NORMNODE, PTABLE )
%    PTABLE, pointer to the table this normalizer feeds into, or pointer to
%    this normalizer
%
%    OK = false -> msg is an error condition
%    OK = true  -> msg is some information
%

%  Copyright 2000-2003 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:33:24 $ 

ok = true;
msg = '';

M = get( node, 'managers');
if isempty( M.AutoSpaceManager )
    [M.AutoSpaceManager,OK] = bpinit(tableptr.info);
end

[M.AutoSpaceManager,OK] = gui_setup(M.AutoSpaceManager,'figure',{'expanded',1,'title', 'Breakpoint Initialization Options'});
node = set(node, 'managers',M);

if OK
    try
        [tableptr.info,cost, OK, msg] = run(M.AutoSpaceManager,tableptr.info,[]);
        if ~OK
            msg = sprintf('Cannot initialize the breakpoints. %s', msg);
            ok = false;
        else
            msg = sprintf('Initialized breakpoints. %s', msg);
            ok = true;
        end
    catch
        msg = sprintf('Unknown error occurred during breakpoint initialization. %s', lasterr);
        ok = false;
    end
end
