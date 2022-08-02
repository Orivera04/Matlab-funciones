function err_disp(modelName,msgType,errMsg,varargin)
%ERR_DISP will display error or warning messages in a dialog.
%   ERR_DISP(MODELNAME, MSGTYPE, ERRMSG)
%         
%   INPUT:
%         modelName: name of model to generate code for
%         msgType:     message type, 'Error', 'Warning'
%         errMsg:         error or warning message. It is in the format of char. array. 
%              

%  Linghui Zhang
%  Copyright 2002-2004 The MathWorks, Inc.
%  $Revision: 1.1.4.4 $
%  $Date: 2004/04/15 00:27:59 $

mpmResult = rtwprivate('rtwattic', 'AtticData', 'mpmResult');

if isempty(mpmResult) | isfield(mpmResult,'err')==0
     mpmResult.err.MemMode = 0;
end
    
if mpmResult.err.MemMode == 0
    slsfnagctlr('Clear', modelName, 'RTW Embedded Coder Module Packaging Tool');
    if isempty(modelName)
        mpmResult.err.MemMode = 2;
    else
        mpmResult.err.MemMode = 1;
    end
end
if mpmResult.err.MemMode == 2 && ~isempty(modelName)
    slsfnagctlr('Rename', '', modelName);
    mpmResult.err.MemMode = 1;
end
rtwprivate('rtwattic', 'AtticData', 'mpmResult',mpmResult);
nag = slsfnagctlr('NagTemplate');
switch msgType
    case 'Error'
        nag.type = 'Error';
    case 'Warning'
        nag.type = 'Warning';
    otherwise
         disp('Unknown type');
end
nag.msg.type       = 'MPT';
if isempty(varargin) == 0
   errDetail = varargin{1};
   nag.msg.details =  sprintf('Model: "%s"\n  %s', modelName, errDetail);
else
   nag.msg.details =  sprintf('Model: "%s"\n  %s', modelName, errMsg);
end
nag.msg.summary = errMsg;
nag.sourceName     = modelName;
nag.sourceFullName = '';
nag.component      = 'MPT';
nag.sourceHId= '';
nag.ids= [];
slsfnagctlr('Naglog', 'push', nag);
slsfnagctlr('ViewNaglog');
