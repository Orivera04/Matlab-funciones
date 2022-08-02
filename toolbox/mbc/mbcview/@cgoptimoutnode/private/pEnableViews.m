function pEnableViews(d, pOptim)
%PENABLEVIEWS Private function to enable view buttons in browser
%
%  PENABLEVIEWS(VIEWDATA, POPTIM)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 08:27:48 $ 

% The pareto, weighted pareto and best solution views only enable if there
% is data for them
tb_en = {'off'; 'off'; 'off'};
menu_en = {'off'; 'off'; 'off'; 'off'; 'off'};
solsize = pOptim.getsolutionsize;

if pOptim.hasselectedsolution
    menu_en{1} = 'on';
    tb_en{1} = 'on';
    if d.CurrentView==1 || d.CurrentView==2
        menu_en{3} = 'on';
        tb_en{3} = 'on';
    end
end
if d.CurrentView~=3
    menu_en{2} = 'on';
    tb_en{2} = 'on';
end

if d.CurrentView==1 || d.CurrentView==4
    menu_en{4} = 'on';
    menu_en{5} = 'on';
end

tb_hndls = [d.Handles.Toolbar.View(4), ...
        d.Handles.Toolbar.ExportToDS, d.Handles.Toolbar.SelectSol];

menu_hndls = [d.Handles.Menu.View(4), ...
        d.Handles.Menu.ExportToDS, d.Handles.Menu.SelectSol, ...
        d.Handles.Menu.ShowConList, d.Handles.Menu.ShowConGraphs];

set(tb_hndls,  {'enable'}, tb_en);
set(menu_hndls, {'enable'}, menu_en);