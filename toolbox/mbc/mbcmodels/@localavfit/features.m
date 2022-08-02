function [Feats,Defaults,Values]=features(f)
%LOCALAVFIT/FEATURES response features common to all localmods
%
% currently this is limited to function values
% when implementing a child class you can choose not to use these
% rfs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 07:37:39 $

labs= labels(f,0);

Display= [labs(:)' {'Constant'}];
Names= Display;
Function=cell(size(Names));
delG= Function;
ind= num2cell(1:length(Display));
for i=1:length(labs);
   Function{i}= 'p(i)';
   delG{i}= 'delparam(f,i)';
end
Function{end}= '1';
delG{end}= 'zeros(1,size(f,1))';

Feats= struct('Display',Display,...
   'Function',Function,...
   'delG',delG,...
   'Name',Names,...
   'IsDatum',0,...
   'index',ind,...
   'IsLinear',1);

Defaults= [];
Values=zeros(0,nfactors(f));
