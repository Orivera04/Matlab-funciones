function paramList = get_mpt_param_list(modelName)
%GET_MPT_PARAM_LIST

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  
%   $Date: 2004/04/15 00:27:06 $

blk=find_system(modelName,'FollowLinks','off','LookUnderMasks','functional','Type','block');
paramList=[];
for i=1:length(blk)
    
    obj = get_param(blk{i},'Object');
    pObj=[];
    dontDoItFlag= 0;
    
    switch(obj.blocktype)
        case 'Constant'
            blockParamInfo = anal_block_param(obj,1);
            pObj = anal_param_str(obj,'Value',1,0);
            blockParamInfo.pObj{1}=pObj;
            
        case 'Gain'
            blockParamInfo = anal_block_param(obj,1);
            pObj = anal_param_str(obj,'Gain',1,1);
            blockParamInfo.pObj{1}=pObj;
        case 'Lookup'
            blockParamInfo = anal_block_param(obj,2);
            pObj = anal_param_str(obj,'InputValues',2,[0,1,2,3,4,5]);
            blockParamInfo.pObj{1}=pObj;
            pObj = anal_param_str(obj,'OutputValues',2,[0,1,2,3,4,5]);
            blockParamInfo.pObj{2}=pObj;
                    case 'Lookup2D'
            blockParamInfo = anal_block_param(obj,2);
            pObj = anal_param_str(obj,'RowIndex',2,[0,1,2,3,4,5]);
            blockParamInfo.pObj{1}=pObj;
            pObj = anal_param_str(obj,'ColumnIndex',2,[0,1,2,3,4,5]);
            blockParamInfo.pObj{2}=pObj;
                        pObj = anal_param_str(obj,'OutputValues',2,[0:5;0:5;0:5;0:5;0:5;0:5]);
            blockParamInfo.pObj{2}=pObj;
        case 'Relay'
            blockParamInfo = anal_block_param(obj,2);
            pObjOn = anal_param_str(obj,'OnSwitchValue',1,1);
            pObjOff = anal_param_str(obj,'OffSwitchValue',1,0);
            blockParamInfo.pObj{1}=pObjOn;
            blockParamInfo.pObj{2}=pObjOff;
            
        otherwise
            dontDoItFlag = 1;
    end
    if dontDoItFlag == 0
        paramList{end+1}=blockParamInfo;
    end
end

tuneInfo = ec_get_sf_tunable(modelName);
paramList=[paramList,tuneInfo];
for k=1:length(paramList)
    name{k} = paramList{k}.pObj{1}.name;
end
[a,b,c] = unique(name);
paramList = paramList(b);
refWSVars = get_param(modelName, 'ReferencedWSVars');

%-----------------------------------------------------------------
function pObj = anal_param_str(obj,pFiledName,minSize,defaultValue)

pObj = [];

pObj.minDim = 1;   %default value. Override for each block is possible.
paramStr = getfield(obj,pFiledName);
pObj.name = paramStr;

    value = str2num(paramStr);
    if (isempty(value) == 1) && (valid_object_name(paramStr) == 0)
        pObj.value = [];
        pObj.paramRef='WSName';
        if  evalin('base', ['exist(''',pObj.name,''')']) == 0
            
            assignin('base',pObj.name,defaultValue);
            
            pObj.exist=0;
        else
            pObj.exist=1;
        end
    else
        pObj.value = value;
        pObj.paramRef = 'Value';
    end


function  blockParamInfo = anal_block_param(obj,numberOfParam)
blockParamInfo=[];
blockParamInfo.srcBlkHandle = obj.Handle;
blockParamInfo.blocktpye = obj.blocktype;
blockParamInfo.numberOfParam = numberOfParam;

function status = valid_object_name(name)
status = 0;
for i=1:length(name)
    if ~(((name(i) >= 'a') && (name(i) <= 'z')) ...
            || ((name(i) >= 'A') && (name(i) <= 'Z'))...
            || ((name(i) >= '0') && (name(i) <= '9'))...
            || (name(i) == '_'))
        status = -1;
        return;
    end
end
