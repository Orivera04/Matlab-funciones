function mpt_function_manager2(modelName)
%MPT_FUNCTION_MANAGER creates the function manager GUI.
%
%   MPT_FUNCTION_MANAGER(MODELNAME, MPTGUIHANDLE)
%         Create function manager dialog.
%
%   INPUT:
%         modelName:     Name of model.
%         mptGUIHandle:  Handle of MPT Main GUI

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $
%   $Date: 2003/09/18 18:05:18 $

% Revision History
%     Version 1.6    Steve Toeppe
% Add refresh of internal header file information. Add in model name and file
% select value to fm structure 
global ecac;
blockPath = find_mpt_block(modelName);
guiType = mpt_gui_technology;
if strcmp(guiType,'hg') == 1
    mptGUIHandle = gcf;
    fm = get(mptGUIHandle,'UserData');
else
    configSet = get_mpt_daconfig(modelName);
    fm = configSet.functionManagerData;
end

if isfield(fm,'hFig') == 1
    try

delete(fm.hFig);
fm.hFig=[];
    catch
        fail=1;
    end
end

fm.blockPath = blockPath;
fm.modelName = modelName;
fm.fileSelValue = 1;
bx=1;
by=1;
w = 200;

fm.modelName=modelName;
fm.bx=1;
fm.by=1;
fm.w1 = 140;
fm.w2 = 140;
fm.w3 = 130;
fm.w4 = 140;
fm.h = 18;
fm.lh =240;
fm.hm = 21;  %heigth with margin
fm.m = 3;    %margin
fm.sPos = get(0,'ScreenSize');
fp.fx = fm.sPos(3)-700;
if fp.fx < 1
    fp.fx = 1;
end
fp.fy = 200;

fm.hFig = figure('MenuBar', 'none',...
    'Name',['MPT Function Manager : ',modelName],...
    'Color',                              get(0,'FactoryUicontrolBack'), ...
    'Units',                              'pixels', ...
    'Resize',                             'off', ...
    'NumberTitle',                        'off', ...
    'Position',[fp.fx,fp.fy,fm.w1+fm.w2,fm.lh+2*fm.h],...
    'DefaultUicontrolUnits',              'pixels');%, ... 

fileList=[];
functionList=[];
packInfo = ecac.packInfo;
for i=1:length(packInfo.filePackage)
    fileList{i}=packInfo.filePackage{i}.fileName;
end
for i=1:length(packInfo.filePackage{1}.functionList)
    functionList{i}=packInfo.filePackage{1}.functionList{i}.functionName;
end
fm.fileList = fileList;
fm.functionList = functionList;
fm.fileFunList=packInfo.filePackage;
%  "File Name" Title over File List Box
fm.th1 = uicontrol('Style','Text',...
    'Position',[fm.bx,fm.lh+1,fm.w1,fm.h],...
    'HorizontalAlignment','Left',...
    'String','File Name');

%  File List Box
fm.lh1 = uicontrol('Style',   'List',...
    'String',fileList,...
    'Enable','on',...
    'Callback',['mpt_fm_callback2(''file_select'',''','',''')'],...
    'Position',[fm.bx,fm.by,fm.w1,fm.lh]);

%  "Function Name" Title over File List Box
fm.th2 = uicontrol('Style','Text',...
    'Position',[fm.bx+fm.w1,fm.lh+1,fm.w2,fm.h],...
    'HorizontalAlignment','Left',...
    'String','Function Name');

% Function List Box
fm.lh2 = uicontrol('Style',   'ListBox',...
    'String',functionList,...
    'CallBack', '',...
    'Enable','on',...
    'Callback',['mpt_fm_callback2(''fun_select'',''','',''')'],...
    'Position',[fm.bx+fm.w1,fm.by,fm.w2,fm.lh]);


if strcmp(guiType,'hg') == 1
set(fm.hFig,'UserData',fm);

set_param(blockPath,'UserData',fm);
set(mptGUIHandle,'UserData',fm);
else
    configSet.functionManagerData = fm;
end
mpt_fm_callback2('fun_select_base', fm.hFig);

mpt_fm_callback2('RefreshInternal',fm);



function value = get_Internal_Approach_Value(inclusionApproach)

switch(inclusionApproach)
    case 'Direct Inclusion'
        value = 1;
    case 'Single Headers'
        value = 2;
    case 'Individual Headers'
        value = 3;
    otherwise
        value = 1;
end