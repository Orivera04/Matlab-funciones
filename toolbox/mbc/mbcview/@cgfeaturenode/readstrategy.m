function featnode = readstrategy( featnode, sys, block )
%READSTRATEGY Reads a Simulink model into a feature
%
%  FEATNODE = READSTRATEGY( FEATNODE, SYS, BLKH )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $    $Date: 2004/04/04 03:33:26 $

if nargin==1
    sys=get_param(gcs,'handle');
    block=get_param(gcb,'handle');
end

% Get the pointers that are currently in the feature before starting.  This
% cannot be done after parsing because the parsing process alters the
% strategy links.
sfPtr = getdata(featnode);
eq = sfPtr.get('equation');
if isempty(eq)
    oldPtrList= [];
else
    oldPtrList=unique([eq; eq.getptrsnosf]);
end

%-----------------------------------
%   (1) Parse out simulink diagram
%-----------------------------------
allblocks = find_system(sys,'findall','on','lookundermasks','all',...
    'Type','block');
set_param( allblocks, 'priority', '0', 'linkstatus','none')

try
    root_system = bdroot(sys);
    creator = get_param(root_system,'Creator');
    if strncmp('Automatically created by CAGE',creator,29)
        s = sys;
    else
        s = bdroot(sys);
    end
    if bdroot(block) ~= sys || ~strcmp(get_param(block,'blocktype'),'Outport')
        % gcb is the wrong block
        block = find_system(s,'searchdepth',1,'BlockType','Outport');
        if length(block) ~= 1
            % Either no outports, or many outports
            return;
        end
    end
    [newsf,e] = cgsl2expr(s,block);
    % Close simulink diagram(s)
    set_param( sys, 'open', 'off' );
    set_param( root_system, 'open', 'off' );
    
    Callbacks( featnode, 'i_SLClose', [], []);
    
    % call private method to do the project clean up
    featnode = pupdateproject(featnode, newsf, e, root_system, oldPtrList);
   
catch
    le = lasterror;
    % ParseError have been deal with - We are left with 'unknown
    % errors'
    if ~strcmp( le.identifier, 'mbc:cgsl2expr:ParseError')
        str = {'Some problems encountered in the parsing of the block diagram',lasterr};
        uiwait( xregerror( 'Parse Problem', str ) );
    end
    if ~isempty(sys)
        set_param(sys,'open','off');
    end
    Callbacks( featnode, 'i_SLClose', [], []);
    return
end
