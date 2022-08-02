function [Feats,Defaults,Values]=features(f)
%LOCALMULTI/FEATURES response features common to localmulti
%
% currently this is limited to function values
% when implementing a child class you can choose not to use these
% rfs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 07:39:56 $


Display = {'Constant'};
Names   = {'Constant'};
Function= {'1'};
delG= {'zeros(1,numParams(f))'};
IsDatum = {0};


Feats= struct('Display',Display,...
   'Function',Function,...
   'delG',delG,...
   'Name',Names,...
   'IsDatum',IsDatum,...
   'index',1,...
   'IsLinear',0);

Defaults=[];
Values=zeros(0,nfactors(f));
