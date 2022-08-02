function [status,errmsg] = check_status(modelName,buildDir)
%[STATUS,ERRMSG] = CHECK_STATUS will check for an error in the model.
%
%   CHECK_STATUS(MODELNAME, BUILDDIR)


%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2003/12/31 19:43:54 $
status = [];
errmsg = '';
try
%     mpt_create_rtw(modelName,buildDir);
    status = 0;
catch
    msg='';
 
    errmsg = lasterr;

    if length(errmsg) > 0

        slsfnagctlr('Clear', modelName, 'MPT')
        
        
        
        nag                =  slsfnagctlr('NagTemplate');
        nag.msg.details =  sprintf('Model: "%s"\n  %s', modelName, errmsg);
        nag.type           = 'Error';                             % type of NAG (Error, Warning, Log, Diagnostic)
        nag.msg.type       = 'Build';                             % the type of message
        %        nag.msg.details    = 'parse error '; % your detailed message
        nag.msg.summary    =  nag.msg.details;                    % typically, the same as details (will truncate)
        nag.sourceFullName = modelName;                   % complete path to the error source
        nag.sourceName     = 'Gain1';                             % blockName or modelName or stateName, etc.
        nag.component      = 'MPT';                               % who's reporting this NAG
        
        slsfnagctlr('Naglog','push', nag);
        slsfnagctlr('View');
        
        status = -1;
    else
        status = 0;
    end
end

