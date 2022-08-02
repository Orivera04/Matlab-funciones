function [sys_out,sname,GbMd]=mv2sl(m,DO_PEV,parentsys)
%MV2SL A short description of the function
%
%  OUT = MV2SL(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:37:47 $ 

[sys_out,sname,GbMd] = mv2sl(m.model, DO_PEV, parentsys);