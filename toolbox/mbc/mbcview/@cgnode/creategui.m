function [lyt,tblyt,data]= creategui(nd,info)
%CREATEGUI  Create a view layout for the node
%
%  [lyt,tblyt,data]= creategui(nd,info);
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:49 $



str='This is the default view for node objects.';

lyt=xregborderlayout(info.Figure,'center',uicontrol('style','text','enable','inactive',...
   'visible','off','parent',info.Figure,'string',str),...
   'innerborder',[10 10 10 10]);

tblyt=[];
data=[];