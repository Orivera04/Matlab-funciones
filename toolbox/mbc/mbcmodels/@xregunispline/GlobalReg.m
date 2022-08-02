function varargout= GlobalReg(m,action,varargin)
% This sets up the Free Knot Optimisation problem.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:30:49 $
switch lower(action)
    case 'create'
        varargout{1} = varargin{3};
    case 'update'

    case 'show'
        varargout{1} = varargin{2};
    case 'hide'

    case 'subfigure'
        varargout{1}= i_SubFigure(varargin{:});
    case 'buildmodels'
        i_buildmodels(m,varargin{:});
    case 'globalmenus'
        % model dpt menus
        varargout{1}= [];
end


% -----------------------------------------------
% function i_SUBFIGURE
% -----------------------------------------------
% open subfigures
function chH= i_SubFigure(Action,hFig,p)

if nargin<2
    p= get(MBrowser,'CurrentNode');
end

chH=[];
switch lower(Action)
    case 'transform'
        chH= mv_boxcox('create',p);
    case 'fitoptions'
        chH= OptionsGUI(p.model,'create');
    case 'buildmodel'
        chH= ModelBuildGUI(p.model,'create');
end


% -----------------------------------------------
% function i_buildmodels
% -----------------------------------------------
function i_buildmodels(m,minK,maxK)

if minK >= maxK
    return
end

mbH= MBrowser;
hFig= double(mbH.Figure);
% get current node
p= mbH.CurrentNode;

CurrentStatus= 0;

ptr= get(hFig,'pointer');
set([hFig;gcbf],'pointer','watch');

if ~CurrentStatus
    try
        mbH.GUILocked= true;
        setProgressBar(mbH,'value', 0);
        msgID = addStatusMsg(mbH, 'Fitting Free Knots...');
        inc=1;
        for i = minK:maxK
            set(m,'max_knots',i)
            set(m,'numknots',i)
            pch= modeldev(m,p);
            pch.name(name(m));
            mbH.treeview(pch,'add');
            OK=pch.fitmodel;
            if nargin>2
                setProgressBar(mbH,'value', inc./ maxK-minK+1);
                inc=inc+1;
            end
        end
        setProgressBar(mbH,'value',0);
        removeStatusMsg(mbH, msgID);
        [S,Chead]= childstats(info(p));
        ind= strmatch('log10(GCV)',Chead,'exact');
        if isempty(ind)
            ind= strmatch('RMSE',Chead,'exact');
        end
        [sm,i]=min(S(:,ind));
        p.BestModel(p.children(i));

        % update modelbrowser
        mbH.RedrawNode;
    catch
        removeStatusMsg(mbH, msgID);
        setProgressBar(mbH,'value',0);
    end
    mbH.GUILocked= false;
end
set([hFig;gcbf],'pointer',ptr);
