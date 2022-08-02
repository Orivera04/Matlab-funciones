function mpt_fm_callback2(operation, value)
%MPT_FM_CALLBACK is processes callbacks from the function manager GUI.
%
%   MPT_FM_CALLBACK(OPERATION, VALUE)
%         Process callbacks from the function manager gui Dialog.
%
%   INPUT:
%         operation: Specific GUI option to process
%         value: arument from GUI

%   Steve Toeppe
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $
%   $Date: 2004/04/15 00:27:30 $

% Revision History
%     Version 1.4    Steve Toeppe
% Add in internal header file refresh operation, chart/graphical function
% indicator and revised default internal header update. Clean up commented
% out code.

global mpmguiflag;
global second_pass;



modelName = bdroot;

guiType = mpt_gui_technology;
if strcmp(guiType,'hg') == 1
    mptGUIHandle = gcf;
    fm = get(mptGUIHandle,'UserData');
else
    configSet = get_mpt_daconfig(modelName);
    fm = configSet.functionManagerData;
end
switch (operation)
    case 'fm_resize'

        pos = get(fm.hFig,'Position');
        width=pos(3);
        height = pos(4);
        fm.bfx=pos(1);
        fm.bfy=pos(2);
        if ((height - 11*fm.hm - 1*fm.h) > 0)
            fm.lh=height-fm.hm;
        else
            fm.lh=11*fm.hm;
        end
        if (width > 433) &((width-fm.w3) > 0)
            fm.w1=(width-fm.w3)*200/600;
            fm.w2=fm.w1;
            fm.w4=fm.w1;
        end
        fm_resize(fm);
    case 'file_select'
        oh = gco;
        value = get(oh,'Value');
        fileSelValue = get(fm.lh1,'Value');


        %         handle = fm.fileFunList{fileSelValue}.function{1}.handle;
        %         funOption = get_mpt_fun_option(handle);
        %         set(fm.fneh, 'String',funOption.internalFileName);
        if value >= 1
            fm.functionList=[];
            for i=1:length(fm.fileFunList{value}.functionList)
                fm.functionList{i}=fm.fileFunList{value}.functionList{i}.functionName;
            end
            set(fm.lh2,'String',fm.functionList,...
                'Value',1);
            mpt_fm_callback2('fun_select', 1);
        end

        %         update_internal_approach(fm,modelName,funOption.internalFileName);

    case 'fun_select'
        fun_sel_update(value,fm);
    case 'fun_select_base'
        fun_sel_update(value,fm);
    case 'GenReplace'

        oh = gco;
        value = get(oh,'Value');
        valueStr = gen_replace_update(fm,value);

        [fileName, funName, handle] = get_file_fun(fm);
        funOption = get_mpt_fun_option(handle);
        %GenUnique='Gen','Replace'
        funOption.genReplace = valueStr;
        set_mpt_fun_option(handle,funOption);
    case 'ExportFrom'

        oh = gco;
        value = get(oh,'Value');
        if value == 0
            valueStr = 'off';
        else
            valueStr = 'on';
        end
        [fileName, funName, handle] = get_file_fun(fm);
        funOption = get_mpt_fun_option(handle);
        %ExportFrom='on','off'
        funOption.exportFrom = valueStr;
        set_mpt_fun_option(handle,funOption);
    case 'GenUnique'

        oh = gco;
        value = get(oh,'Value');
        if value == 0
            valueStr = 'off';
        else
            valueStr = 'on';
        end
        [fileName, funName, handle] = get_file_fun(fm);
        funOption = get_mpt_fun_option(handle);
        %GenUnique='on','off'
        funOption.genUnique = valueStr;
        set_mpt_fun_option(handle,funOption);

    case 'ExportHeader'

        oh = gco;
        valueStr = get(oh,'String');
        [fileName, funName, handle] = get_file_fun(fm);
        %GenUnique='on','off'
        funOption = get_mpt_fun_option(handle);
        funOption.exportHeader = valueStr;
        set_mpt_fun_option(handle,funOption);
    case 'InternalFileName'

        oh = gco;
        valueStr = get(oh,'String');
        fileSelValue = get(fm.lh1,'Value');
        %GenUnique='on','off'
        miscOptions = get_misc_options(modelName);
        switch(miscOptions.InternalApproach)
            case 'Individual Headers'
                handle = fm.fileFunList{fileSelValue}.function{1}.handle;
                funOption = get_mpt_fun_option(handle);
                funOption.internalFileName = valueStr;
                set_mpt_fun_option(handle,funOption);
            otherwise
                set_scope_info(modelName,'internalHeaderFile', valueStr);
        end


    case 'ReplaceHeader'

        oh = gco;
        valueStr = get(oh,'String');
        [fileName, funName, handle] = get_file_fun(fm);
        funOption = get_mpt_fun_option(handle);
        %GenUnique='on','off'
        funOption.replaceHeader=valueStr;
        set_mpt_fun_option(handle,funOption);
    case 'InternalNameOverride'
        oh = gco;
        value = get(oh,'Value');
        if value == 0
            valueStr = 'off';
            set(fm.fnth,'Enable','off');
            set(fm.fneh,'Enable','off');

        else
            valueStr = 'on';
            set(fm.fnth,'Enable','on');
            set(fm.fneh,'Enable','on');

        end
        value = get(fm.lh1,'Value');
        handle = fm.fileFunList{value}.function{1}.handle;
        funOption = get_mpt_fun_option(handle);
        %ExportFrom='on','off'
        funOption.internalNameOverride = valueStr;
        set_mpt_fun_option(handle,funOption);
    case 'FMClose'
        if isfield(fm,'hFig') == 1
            delete(fm.hFig);
        end
    case 'InternalApproach'
        value = get(gcbo,'Value');
        fileSelValue = get(fm.lh1,'Value');


        handle = fm.fileFunList{fileSelValue}.function{1}.handle;
        funOption = get_mpt_fun_option(handle);
        set(fm.fneh, 'String',funOption.internalFileName);
        set_miscellaneous_options(modelName,'InternalApproach',get_Internal_Approach_UDDEnum(value));
        update_internal_approach(fm,modelName,funOption.internalFileName);
    case 'RefreshInternal'
        fm = value;
        fileSelValue = fm.fileSelValue;
        modelName = fm.modelName;
        %         handle = fm.fileFunList{fileSelValue}.function{1}.handle;
        %         funOption = get_mpt_fun_option(handle);
        %         update_internal_approach(fm,modelName,funOption.internalFileName);
    case 'RefreshFile'
        try
            fm = value;
            %             fp = get_file_package(modelName);
            %             fileList=[];
            %             functionList=[];
            %             for i=1:length(fp.fileFunList)
            %                 fileList{i}=fp.fileFunList{i}.name;
            %             end
            %             for i=1:length(fp.fileFunList{1}.function)
            %                 functionList{i}=fp.fileFunList{1}.function{i}.name;
            %             end

            o=get_param(modelName,'Object');
            o = special_engine_init(o);
            packInfo = mpt_package_and_data(modelName,o);
            o.term;
            fileList=[];
            functionList=[];
            for i=1:length(packInfo.filePackage)
                fileList{i}=packInfo.filePackage{i}.fileName;
            end
            for i=1:length(packInfo.filePackage{1}.functionList)
                functionList{i}=packInfo.filePackage{1}.functionList{i}.functionName;
            end
            fm.fileList = fileList;
            fm.functionList = functionList;
            fm.fileFunList=fp.fileFunList;
            set(fm.lh1,'String',fileList,'Value',1);
            set(fm.lh2,'String',functionList,'Value',1);
            handle = fm.fileFunList{1}.function{1}.handle;
            funOption = get_mpt_fun_option(handle);
            set(fm.fneh, 'String',funOption.internalFileName);
            set(fm.hFig,'UserData',fm);

            set_param(fm.blockPath,'UserData',fm);
        catch
        end
    otherwise
end


function fm_resize(fm)
set(fm.hFig,...
    'Position',[fm.bfx,fm.bfy,fm.w1+fm.w2+fm.w3+fm.w4+fm.m,fm.lh+fm.h]);
set(fm.th1,...
    'Position',[fm.bx,fm.lh+1,fm.w1,fm.h]);

%  File List Box
set(fm.lh1,...
    'Position',[fm.bx,fm.by,fm.w1,fm.lh]);

%  "Function Name" Title over File List Box
set(fm.th2,...
    'Position',[fm.bx+fm.w1,fm.lh+1,fm.w2,fm.h]);

% Function List Box
set(fm.lh2,...
    'Position',[fm.bx+fm.w1,fm.by,fm.w2,fm.lh]);

set(fm.frmfnh,...
    'Position',[fm.bx+fm.w1+fm.w2+fm.m,fm.lh-4*fm.hm-6,fm.w3+fm.w4+5*fm.m,5*fm.h+6]);
set(fm.frmfnh2,...
    'Position',[fm.bx+fm.w1+fm.w2+fm.m,fm.lh-10*fm.hm-5,fm.w3+fm.w4+5*fm.m,6*fm.h+6]);
set(fm.intth,...
    'Position',[fm.bx+fm.w1+fm.w2+3*fm.m,fm.lh+0*fm.hm,fm.w3+60,fm.h]);
set(fm.intth2,...
    'Position',[fm.bx+fm.w1+fm.w2+3*fm.m,fm.lh-1*fm.hm,fm.w3+75,fm.h]);
set(fm.frmfntha ,...
    'Position',[fm.bx+fm.w1+fm.w2+3*fm.m,fm.lh-5*fm.hm-7,fm.w3+20,fm.h]);
set(fm.intpuh,...
    'Position',[fm.bx+fm.w1+fm.w2+3*fm.m+55,fm.lh-1*fm.hm+3,fm.w3+92,fm.h]);

set(fm.fndth ,...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m,fm.lh-2*fm.hm,fm.w3,fm.h]);
set(fm.fndeh , ...
    'Position',[fm.bx+fm.w1+fm.w2+fm.w3+2*fm.m+10,fm.lh-2*fm.hm,fm.w4,fm.h]);
set(fm.fncbh, ...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m,fm.lh-3*fm.hm,fm.w3+90,fm.h]);
set(fm.fnth, ...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m+20,fm.lh-4*fm.hm,fm.w3,fm.h]);

set(fm.fneh, ...
    'Position',[fm.bx+fm.w1+fm.w2+fm.w3+fm.m+10,fm.lh-4*fm.hm,fm.w4,fm.h]);
set(fm.fcth,...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m,fm.lh-6*fm.hm,fm.w3,fm.h]);
set(fm.gfth,...
    'Position',[fm.bx+fm.w1+fm.w2+fm.w3+2*fm.m+10,fm.lh-6*fm.hm,fm.w4,fm.h]);
set(fm.puh,...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m,fm.lh-7*fm.hm,fm.w3,fm.h]);

set(fm.cb1h,...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m,fm.lh-8*fm.hm,fm.w3,fm.h]);

set(fm.cb2,...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m+20,fm.lh-9*fm.hm,fm.w3+90,fm.h]);

set(fm.epth,...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m+20,fm.lh-10*fm.hm,fm.w3,fm.h]);

set(fm.epeh,...
    'Position',[fm.bx+fm.w1+fm.w2+fm.w3+fm.m+10,fm.lh-10*fm.hm,fm.w4,fm.h]);

set(fm.cb3h,...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m,fm.lh-11*fm.hm,fm.w3+fm.w4,fm.h]);

set(fm.ept2h,...
    'Position',[fm.bx+fm.w1+fm.w2+2*fm.m,fm.lh-8*fm.hm,fm.w3,fm.h]);

set(fm.epe2h,...
    'Position',[fm.bx+fm.w1+fm.w2+fm.w3+fm.m+10,fm.lh-8*fm.hm,fm.w4,fm.h]);


function [fileName, funName, handle] = get_file_fun(fm)
fileSelValue = get(fm.lh1,'Value');
funSelValue = get(fm.lh2,'Value');

fileName = fm.fileFunList{fileSelValue}.fileName;
funName = fm.fileFunList{fileSelValue}.functionList{funSelValue}.functionName;
handle = [];%fm.fileFunList{fileSelValue}.function{funSelValue}.handle;

function set_on_off(valueStr,handle)
if isempty(valueStr) == 0
    switch(valueStr)
        case 'off'
            set(handle,'Value',0);
        case 'on'
            set(handle,'Value',1);
        otherwise
            set(handle,'Value',0);
    end
else
    set(handle,'Value',0);
end

function valueStr = gen_replace_update(fm,value)
if value == 1
    set(fm.cb1h,'Visible','on');  %export from module checkbox
    set(fm.epth,'Visible','on');  %pre edit field text
    set(fm.epeh,'Visible','on');  %edit field
    set(fm.cb2,'Visible','on');   %generate unique prototype
    set(fm.cb3h,'Visible','off'); %replace checkbox
    set(fm.ept2h,'Visible','off'); %external pre edit text
    set(fm.epe2h,'Visible','off');%external edit field
    valueStr = 'Gen';
else
    set(fm.cb1h,'Visible','off');  %export from module checkbox
    set(fm.epth,'Visible','off');  %pre edit field text
    set(fm.epeh,'Visible','off');  %edit field
    set(fm.cb2,'Visible','off');   %generate unique prototype
    set(fm.cb3h,'Visible','on'); %replace checkbox
    set(fm.ept2h,'Visible','on'); %external pre edit text
    set(fm.epe2h,'Visible','on');%external edit field
    valueStr = 'Replace';
end


function fun_sel_update(handle,fm)

[fileName, funName, handle] = get_file_fun(fm);
% funOption = get_mpt_fun_option(handle);
% genReplaceStr = 'Gen';
% exportFromStr = 'off';
% genUniqueStr = 'off';
% exportHeaderStr = '';
% replaceHeaderStr = '';
%
% switch(funOption.genReplace)
%     case 'Gen'
%         set(fm.puh,'Value',1);
%         value = 1;
%     case 'Replace'
%         set(fm.puh,'Value',2);
%         value = 2;
%     otherwise
%         set(fm.puh,'Value',1);
%         value = 1;
% end
% valueStr = gen_replace_update(fm,value);
% set_on_off(funOption.exportFrom,fm.cb1h);
% set_on_off(funOption.genUnique,fm.cb2);
% set(fm.epeh,'String',funOption.exportHeader);
% set(fm.epe2h,'String',funOption.replaceHeader);
%
% funType = sf('get',handle,'.isa');
% if funType == 1
%     set(fm.gfth,'String','Chart Function');
% else
%     set(fm.gfth,'String','Graphical Function');
% end

function inclusionApproach = get_Internal_Approach_UDDEnum(value)

switch(value)
    case 1
        inclusionApproach ='Direct Inclusion';

    case 2
        inclusionApproach ='Single Headers';

    case 3
        inclusionApproach = 'Individual Headers';

    otherwise
        inclusionApproach ='Direct Inclusion';
end

function update_internal_approach(fm,modelName,internalFileName)
value = get(fm.lh1,'Value');
scopeInfo = get_scope_info(modelName);
miscOptions = get_misc_options(modelName);
handle = fm.fileFunList{value}.function{1}.handle;
funOption = get_mpt_fun_option(handle);
switch(funOption.internalNameOverride)
    case 'on'
        checkValue = 1;
        set(fm.fnth,'Enable','on');
        set(fm.fneh,'Enable','on');
    case 'off'
        checkValue = 0;
        set(fm.fnth,'Enable','off');
        set(fm.fneh,'Enable','off');
    otherwise
        checkValue = 0;
        set(fm.fnth,'Enable','off');
        set(fm.fneh,'Enable','off');
end
set(fm.fncbh,'Value',checkValue);
switch(miscOptions.InternalApproach)
    case 'Direct Inclusion'
        set(fm.fndeh ,'Visible','off');
        set(fm.fndth ,'Visible','off');
        set(fm.fnth  ,'Visible','off');
        set(fm.fneh  ,'Visible','off');
        set(fm.fncbh ,'Visible','off');
    case 'Single Headers'
        headerFileName = scopeInfo.internalHeaderFile;
        set(fm.fndeh ,'Visible','on');
        set(fm.fndth ,'Visible','on');
        set(fm.fnth  ,'Visible','on');
        set(fm.fneh  ,'Visible','on');
        set(fm.fncbh ,'Visible','on');
        set(fm.fneh  ,'String',headerFileName);

        %         if isempty(headerFileName) == 1
        defaultHeaderFileName = ['Int_',modelName];
        %         end
        defaultHeaderFileName = fliplr(deblank(fliplr(deblank(defaultHeaderFileName))));
        set(fm.fndeh ,'String',defaultHeaderFileName);
    case 'Individual Headers'
        set(fm.fndeh ,'Visible','on');
        set(fm.fndth ,'Visible','on');
        set(fm.fnth  ,'Visible','on');
        set(fm.fneh  ,'Visible','on');
        set(fm.fncbh ,'Visible','on');
        if isempty(internalFileName) == 1
            fileName = [strtok(fm.fileFunList{value}.name,'.'),'.h'];
        else
            fileName = internalFileName;
        end
        set(fm.fndeh ,'String',fileName);
    otherwise
        set(fm.fndeh ,'Visible','off');
        set(fm.fndth ,'Visible','off');
        set(fm.fnth  ,'Visible','off');
        set(fm.fneh  ,'Visible','off');
        set(fm.fncbh ,'Visible','on');
end