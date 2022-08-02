function d = view(nd,cgh,d)
%VIEW
%
%  View=view(nd,cgh,View)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:27:46 $

pOpt = getdata(nd);

%%%%%%%%%%%%%% Update information pane %%%%%%%%%%%%%%%%
pr_RefreshInfo(d.Handles.InfoPane, pOpt.info);

%%%%%%%%%%%%%% Fill List Controls %%%%%%%%%%%%%%%%%%%%%
%% Objective List %%
pr_RefreshList(d.Handles.ObjList, nd, d.ILmanager);

%% Data Set List %%
pr_RefreshList(d.Handles.DSList, nd, d.ILmanager);

%% Constraint List %%
pr_RefreshList(d.Handles.ConList, nd, d.ILmanager);

%%%%%%%%%%%%% Enable toolbar and menus %%%%%%%%%%%%%%%%
pr_EnableTM(pOpt.info, d.Handles);