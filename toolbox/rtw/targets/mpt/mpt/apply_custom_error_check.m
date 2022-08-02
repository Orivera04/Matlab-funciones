function [status] = apply_custom_error_check(modelName, errorLC, varargin)
%APPLY_CUSTOM_ERROR_CHECK will allow to put custom error check.
%
%  [STATUS] = APPLY_CUDTOM_ERROR_CHECK(MODELNAME, ERRORLC, VARARGIN)
%         
%   INPUT:
%         modelName: name of model to generate code for
%         errorLC: error Log control, 1: enable error check; 0 disable error check
%                   
%   OUTPUT:
%        status: the status of error check, 1: no Error; 0: Error; -1:Warning   
%

%  Linghui Zhang
%  Copyright 2002 The MathWorks, Inc. 
%  $Revision: 1.1 $
%  $Date: 2002/07/19 17:02:36 $

status = 1; 
if errorLC == 0
    return;
else
    global mpmResult;
    if isempty(mpmResult)
        mpmResult.err.MemMode = 0;
    end
    cr = sprintf('\n');
    checkList = custom_error_check_hook;
    for i = 1:length(checkList)
        errmsg = '';
        [errStatus, msg, failedlist,errType] = feval([checkList{i}(1:end-2)],modelName);
        if errStatus == 0 | errStatus == -1
            if errStatus == 0 
                status = 0;
            elseif errStatus == -1 & status == 0;
                status = 0;
            elseif errStatus == -1 & (status == 1|status == -1);
                status = -1;
            end
            
            if mpmResult.err.MemMode == 0
                slsfnagctlr('Clear', modelName, 'RTW Embedded Coder Module Packaging Tool');
                mpmResult.err.MemMode = 1;
            end
            nag = slsfnagctlr('NagTemplate');
            nag.type = errType;
            nag.msg.type = 'MPT';    
            errmsg = [errmsg,failedlist];               
            nag.msg.details =  sprintf('Model: "%s"\n  %s', modelName, errmsg);
            nag.msg.summary = msg;
            nag.sourceName = modelName;
            nag.sourceFullName = '';
            nag.component = 'MPT';
            nag.sourceHId= '';
            nag.ids= [];
            slsfnagctlr('Naglog', 'push', nag);
            slsfnagctlr('ViewNaglog');
        end
    end
end


