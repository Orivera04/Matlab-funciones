function updatecommand(t,fcn,params)
%TERM_SELECTOR/UPDATECOMMAND   On the fly update command setting
%   updatecommand(t,function,parameters) installs function as the string to use
%   for causing external updates using the model in the term_selector
%   object.  Within the parameters cell array, the string token %MODEL will 
%   cause the model to be inserted at that position, eg
%
%    fcn='mv_doeanalysis'
%    params={'updatemodel','%MODEL'}
%
%   will cause the command mv_doeanalysis('updatemodel',m); to be executed.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:44:15 $


% just quickly check inputs for validity and then chuck them in table userdata

ud=t.xregtable.userdata;
ud.updatefunction=fcn;
ud.updateparams=params;

t.xregtable.userdata=ud;