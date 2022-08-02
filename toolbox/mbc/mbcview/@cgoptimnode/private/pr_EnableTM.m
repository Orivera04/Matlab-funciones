function pr_EnableTM(optim, hdls)
% PR_ENABLETM
%   Set the correct enable status for toolbar and menus

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 08:27:32 $


% Create vector of handles and enable settings
tbhndls = [ ...
        hdls.Toolbar.Run ;...
        hdls.Toolbar.SetUpandRun ;...
        hdls.Toolbar.SetUp ;...
        hdls.Toolbar.AddObj ;...
        hdls.Toolbar.AddCo ;...
        hdls.Toolbar.AddDS ;...
    ];
menuhndls = [ ...
        hdls.RunMenu ;... 
        hdls.SetUpandRunMenu;...
        hdls.SetUpMenu ;...
        hdls.AddObjMenu ;...
        hdls.Contextmenu.AddObj ;...
        hdls.SelObjMenu ;...
        hdls.Contextmenu.SelObj ;...
        hdls.DelObjMenu ;...
        hdls.Contextmenu.DelObj ;...
        hdls.AddConMenu ;...
        hdls.Contextmenu.AddCon ;...
        hdls.EditConMenu ;...
        hdls.Contextmenu.EditCon ;...
        hdls.DelConMenu ;...
        hdls.Contextmenu.DelCon ;...        
        hdls.AddDSMenu ;...
        hdls.Contextmenu.AddDS ;...
        hdls.SelDSMenu ;...
        hdls.Contextmenu.SelDS ;...
        hdls.DelDSMenu ;...
        hdls.Contextmenu.DelDS ;...    
    ];

tben = repmat({'off'}, 6,1);
menuen = repmat({'off'}, 21,1);

ON_VALUE = {'on'};
%%%%%%%% Run optimization 
ok = checkrun(optim, 'gui');
if ok
    menuen(1:2) = ON_VALUE;
    tben(1:2) = ON_VALUE;
end

%%%%%%%% Set up optimization
menuen(3) = ON_VALUE;
tben(3) = ON_VALUE;

%%%%%%%% Objective functions - can we select/add
olabs = get(optim, 'objectivelabels');
if isempty(olabs)
    % No objectives => can't edit or delete
    if get(optim, 'canaddobjectivefuncs')
        menuen(4:5) = ON_VALUE;
        tben(4) = ON_VALUE;
    end    
else
    if get(optim, 'canaddobjectivefuncs')
        menuen([4 5 8 9]) = ON_VALUE;
        tben(4) = ON_VALUE;
    end
    menuen(6:7) = ON_VALUE;
end

%%%%%%%% Constraints - can we select/add 
conlabs = get(optim, 'constraintlabels');
if isempty(conlabs)
    % No constraints => can't edit or delete
    if get(optim, 'canaddconstraints')
        menuen(10:11) = ON_VALUE;
        tben(5) = ON_VALUE;
    end    
else
    if get(optim, 'canaddconstraints')
        menuen([10 11 14 15]) = ON_VALUE;
        tben(5) = ON_VALUE;
    end
    menuen(12:13) = ON_VALUE;
end

%%%%%%%% Data Sets - can we select/add 
dslabs = get(optim, 'oppointlabels');
if isempty(dslabs)
    % Allow addition of data sets, no selection
    if get(optim, 'canaddoppoints')
        menuen(16:17) = ON_VALUE;
        tben(6) = ON_VALUE;
    end
else
    if get(optim, 'canaddoppoints')
        
    end
    % addition?
    if get(optim,'canaddoppoints')==1  || (get(optim,'canaddoppoints')==2 && length(dslabs)==0)
        menuen(16:17) = ON_VALUE;
    end
    % deletion? 
    if get(optim,'canaddoppoints')==1  || (get(optim,'canaddoppoints')==2 && length(dslabs)==1)
        menuen(20:21) = ON_VALUE;
    end
    menuen(18:19) = ON_VALUE;
end

set(tbhndls, {'enable'}, tben);
set(menuhndls, {'enable'}, menuen);