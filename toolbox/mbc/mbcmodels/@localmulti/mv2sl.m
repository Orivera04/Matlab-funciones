function [sys_out,sname,GbMd]=mv2sl(m,DO_PEV,parentsys)
%MV2SL A short description of the function
%
%  OUT = MV2SL(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:40:04 $ 

currentModel = get(m, 'currentmodel');
% Need to set Ytrans correctly
set(currentModel, 'ytrans', get(m, 'ytrans'));
% Call mv2sl on this current model
[sys_out,sname,GbMd] = mv2sl(currentModel, DO_PEV, parentsys);