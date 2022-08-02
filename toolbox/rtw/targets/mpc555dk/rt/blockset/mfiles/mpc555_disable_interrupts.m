function varargout = mpc555_disable_interrupts(action,block,varafinrgin)
%MPC555_DISABLE_INTERRUPTS

%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.12.2.2 $

tag = 'Disable MPC555 Interrupts';

parent = get_param(block,'parent');
if ((isempty(parent)) | ...
    (strcmp(get_param(parent, 'Type'), 'block_diagram')) | ...
    (strcmp(get_param(parent,'TreatAsAtomicUnit'),'off')))
  varargout = {[], [], ['??? ERROR ???\n', ...
        'This block must be placed\n', ...
        'into an atomic subsystem.']};
  return;
end

switch action
case 'init'
    set_param(block,'tag',tag);
case 'getcode'
    % Get the blocks string based name just in case the
    % numeric handle was passed in
    block=[get_param(block,'parent') '/' get_param(block,'name')];
    
    % Tokenize the block along '/' boundaries
    k = java.util.StringTokenizer(block,'/');
    subs = {};
    s = '';
    
    % Get an estimate of the depth of the block
    % and create a cell array large enough. In 
    % most cases this is right except when one
    % of the blocks has / in the name. In this
    % case the below code will still work but it
    % will not be as fast.
    depth = length(findstr(parent,'/'));
    subs = cell(1,depth);
    i = 0;
    while ~isempty(parent)
        i = i + 1;
        subs{i} = parent;
        parent = get_param(parent,'parent');
    end
    % Ensure that there is no empty cell at the
    % end. This will happen if the name of any
    % of the subsystems have / in the name
    subs = {subs{1:i}};
    
    sys = find_system(subs,'lookundermasks','all','followlinks','on','SearchDepth',1,'tag',tag);
    
    if length(sys) == 1
        top = 'EID();';
        bottom = 'EIE();';
        dispstr = 'This subsystem has\ninterrupts disabled\nin its model outputs\nfunction';
    else
        top = '';
        bottom = '';
        dispstr = ['This subsystem has an ancestor\n' ...
                   'who has disabled interrupts.\n' ...
                 'Interrupt disable nesting is being\n' ... 
                 'avoided by ignoring this block.'];
    end
    
    varargout = { top bottom dispstr};
    
    
end


%   $Revision: 1.12.2.2 $  $Date: 2004/04/19 01:29:55 $
