function Feats=features(f)
% LOCALMOD/FEATURES response features common to all localmods
%
% currently this is limited to function values
% when implementing a child class you can choose not to use these
% rfs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:59 $

Display = {'f(x)'};
Names   = {'FX'};
Function= {'eval(f,f.Values(i,:))'};
delG= {'hermiteX(f,f.Values(i,:))'};
IsDatum = {0};


Feats= struct('Display',Display,...
      'Function',Function,...
      'delG',delG,...
      'Name',Names,...
      'IsDatum',IsDatum,...
		'index',1,...
		'IsLinear',0);