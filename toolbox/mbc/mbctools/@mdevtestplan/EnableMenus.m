function OK= EnableMenus(T,View);
% MDEVTESTPLAN/ENABLEMENUS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:07:15 $



% Menu items: [View.menus.testplan]
%    1. 'Set Up &Inputs...'
%    2.  'Set Up &Model...'
%    3.  'Design &Experiment'
%    4.  '&Boundary Constraints'
%    5.  '&Summary Statistics...'
%    6.  '&New Data...'
%    7.  'Select &Data...'
%    8.  'Make &Template...'
%    9.  'E&xport Multimodels'};

OK=1;
NStages= length(T.DesignDev);

set(View.menus.testplan([1:3, 5]),'enable','on')
set(View.menus.viewchild,'enable','on')
set(View.toolbarBtns(1),'enable','on')
set(View.menus.testplan(end),'enable','off')

if NStages>1
    Stage= find(strcmp(get(View.hHSM.hBorder,'selected'),'on'));
    if any(strcmp(get(View.hHSM.hBorder,'selected'),'on'))
        % model selected
        set(View.menus.testplan(1),'enable','off')
        if Stage==1
            % if we are in the first stage of a 2 stage (local) we can't have
            % Summary Stats
            set(View.menus.testplan(5),'enable','off')
        end
    else
        % inport or outport selected
        set(View.menus.testplan(2),'enable','off')
        set(View.menus.testplan(5),'enable','off')
        set(View.menus.viewchild(2),'enable','off')
        if Stage>NStages
            % outport selected
            % no model or doe
            set(View.menus.testplan(1:3),'enable','off')
            set(View.menus.viewchild(1),'enable','off')
            set(View.toolbarBtns(1),'enable','off')
        end
    end
    if nfactors(getModel(T.DesignDev)) ==2
        set(View.menus.testplan(end),'enable','on')
    end
end
if ~T.Matched
    set(View.menus.viewchild(1),'enable','off')
end

% only enable boundary constraint modeling if
%    - matched
if T.Matched
    set( View.menus.testplan(4), 'enable', 'on' )
else
    set( View.menus.testplan(4), 'enable', 'off' )
end