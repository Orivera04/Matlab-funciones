function m= loadobj(LM);
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:19 $

m=LM;
if isa(LM,'struct')
   m= localmod(LM);
end
if ~isfield(m.Type,'index')
	[m.Type.index]= deal(0);
end
if ~isfield(m.Type,'IsLinear')
	[m.Type.IsLinear]= deal(isa(m,'xreglinear') | isa(m,'localpspline'));
end
