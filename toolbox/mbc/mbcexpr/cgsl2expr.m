function [prior,e] = cgsl2expr(s,block)
%CGSL2EXPR Initiating function call to parse a Simulink diagram
%
%  OUT = CGSL2EXPR(simulinkHandle,blockHandle)
%  simulinkHandle - Handle to starting level of the SL Diagram
%  blockHandle - Handle to an outport of the Simulink Diagram

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.13.4.3 $    $Date: 2004/02/09 07:17:34 $ 

% Store the starting point of the parse
% this is used to scope searches for datastores etc
global CGSL2EXPR_STARTLEVEL
CGSL2EXPR_STARTLEVEL = get_param(s,'handle');

prior = [];
portinfo = get_param(block,'portconnectivity');
name = get_param(block,'name');
set_param(block,'selected','off');

ports = get_param(block,'porthandles');
in = cat(1,portinfo.SrcBlock);
line = get_param(ports.Inport,'line');

empty_ptr_array = null( xregpointer, 0 );
% PLIST is a pointer to an array of pointers
PLIST = xregGui.RunTimePointer( empty_ptr_array );

if in==-1
	prior=[];
else
	try
        % make sure no blocks _start_ with a priority of '1'
        i_priority( s, 'cleanup' );
		prior = [prior, cgsl2exprgetprior( in, '', block, line, PLIST )];
        e = PLIST.info;
        delete(PLIST);
        i_clearglobals;
        % and then put them back
        i_priority( s, 'restore' );
	catch        
        % clean up before erroring
        freeptr( PLIST.info );
        i_clearglobals;
        % and then put them back
        i_priority( s, 'restore' );
        rethrow(lasterror);
	end
end

% ---------------------------
function i_priority( s, mode )
% WE need to make sure NO blocks have a priority of '1' before we start
% parsing - this really confuses the parser.  We'll get a list of blocks
% that have this, and also empty that field.
% Later we can restore ths property

persistent blocklist;

switch mode
    case 'clean'
        blocklist = find_system(s, 'Type', 'block', 'Priority', '1');
        if ~isempty( blocklist )
            set_param( blocklist, 'Priority', '');
        end   
    case 'restore'
        if ~isempty( blocklist )
            set_param( blocklist, 'Priority', '1');
        end
        blocklist = {};
end

% ---------------------------
function i_clearglobals
clear global CGSL2EXPR_STARTLEVEL 

