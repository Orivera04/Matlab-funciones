function L=SetFeat(L,Type,Values);
% LOCALMOD/SETFEAT set response feature info
%
%  L=SetFeat(L,Type,Values);
%  L=SetFeat(L,'default');

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:47 $



if isa(Type,'char') & strcmp(lower(Type),'default')
	[Feats,Defaults,DefValues]= features(L);
	if nargin==2
		Values= DefValues;
	end
	Type= Feats(Defaults);
end

L.Values= Values;
L.Type= DatumDisplay(L,Type);
L= EvalDelG(L);
L.Limits= zeros(2,size(Values,1));
L.Limits(1,:)=-Inf;
L.Limits(2,:)= Inf;
