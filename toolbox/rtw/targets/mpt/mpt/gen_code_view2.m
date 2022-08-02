function gen_code_view2(mpmResult)
%GEN_CODE_VIEW2 will put up a dialog with hyperlink references to file names in list.
%
%   GEN_CODE_VIEW(MPMRESULT) take a list of code generation information and
%   register it with the diagnostic viewer. The information is presorted into
%   specific categories.
%
%   INPUT:
%         mpmResult:  Generated file and diagnostic information to be displayed
%

%   Steve Toeppe
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.9.4.3 $
%   $Date: 2004/04/15 00:26:58 $

if  isfield(mpmResult,'result') == 1
    lf=sprintf('\n');
    slsfnagctlr('Clear', mpmResult.modelName, 'RTW Embedded Coder Module Packaging Tool');
    mpmResult.err.MemMode =1;
    
    nag.component= 'MPT';
    nag.type= 'Log';
    nag.refDir= mpmResult.refDir;
    fileListStr=[];
    nag.msg.type= 'MPT';
    
    codeGenListStr = [];
    protoGenListStr = [];
    globalGenListStr = [];
    machineGenListStr = [];
    typeGenListStr=[];
    tableGenListStr=[];
    for i=1:length(mpmResult.codeGenList)
        codeGenListStr = [codeGenListStr,'    "',mpmResult.codeGenList{i},'"',lf];
    end
    
    for i=1:length(mpmResult.protoGenList)
        protoGenListStr = [protoGenListStr,'    "',mpmResult.protoGenList{i},'"',lf];
    end
    
    for i=1:length(mpmResult.globalGenList)
        globalGenListStr = [globalGenListStr,'    "',mpmResult.globalGenList{i},'"',lf];
    end
    
    for i=1:length(mpmResult.machineGenList)  
        machineGenListStr = [machineGenListStr,'    "',mpmResult.machineGenList{i},'"',lf];
    end
        for i=1:length(mpmResult.typeGenList)  
        typeGenListStr = [typeGenListStr,'    "',mpmResult.typeGenList{i},'"',lf];
    end
           for i=1:length(mpmResult.tableGenList)  
        tableGenListStr = [tableGenListStr,'    "',mpmResult.tableGenList{i},'"',lf];
    end
    msg='';
    if isempty(codeGenListStr) == 0
        msg = [msg,'Code Files:',lf,codeGenListStr];
    end
        if isempty(typeGenListStr) == 0
        msg = [msg,'Type Files:',lf,typeGenListStr];
    end
    if isempty(protoGenListStr) == 0
        msg = [msg,'Code Prototype Files:',lf,protoGenListStr];
    end
    if isempty(globalGenListStr) == 0
        msg = [msg,'Global Data Files:',lf,globalGenListStr];
    end
    if isempty(machineGenListStr) == 0
        msg = [msg,'Machine Global Data Files (Automatically Generated to resolve Stateflow Machine Level Data):',lf,machineGenListStr];
    end
        if isempty(tableGenListStr) == 0
        msg = [msg,'Table Data Files:',lf,tableGenListStr];
    end
    nag.msg.details =  sprintf('Model: "%s"\nDirectory: "%s"\n%s', mpmResult.modelName,nag.refDir,msg);
    nag.msg.summary= 'Code Generation Results';
    nag.msg.links= [];
    nag.msg.preprocessedFileLinks= [];
    nag.sourceFullName= '';
    nag.sourceName = mpmResult.modelName;
    nag.sourceHId= '';
    nag.objHandles= [];
    nag.openFcn= '';
    nag.userdata= [];
    nag.ids= [];
    nag.parentSystemH= [];
    nag.time= [];
    nag.blkHandles= [];
    slsfnagctlr('Naglog', 'push', nag);
    slsfnagctlr('ViewNaglog');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add warning info into the log 
    if isfield(mpmResult,'warning') == 1 & isempty(mpmResult.warning) == 0
        for j = 1:length(mpmResult.warning)
            msgsTemp{j} = mpmResult.warning{j}.detailMsg;
        end
        [dmsg,II,JJ] = unique(msgsTemp);
        for j = 1:length(dmsg)
            nag = slsfnagctlr('NagTemplate');
            nag.type = mpmResult.warning{II(j)}.type;
            nag.msg.type = 'MPT';
            nag.msg.details =  sprintf('Model: "%s"\n  %s', mpmResult.modelName, dmsg{j});
            nag.msg.summary = mpmResult.warning{II(j)}.msg ;
            nag.sourceName = mpmResult.modelName;
            nag.component = 'MPT';
            slsfnagctlr('Naglog', 'push', nag);
            slsfnagctlr('ViewNaglog');   
        end
    end
end