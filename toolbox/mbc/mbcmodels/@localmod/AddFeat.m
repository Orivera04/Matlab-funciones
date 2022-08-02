function f=AddFeat(f,Value,Type,Limits)
% LOCALMOD/ADDFEAT add response feature to localmod
%
% f=AddFeat(f,Value,Type,Limits)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 07:38:29 $

f.Values= [f.Values;Value];
switch class(Type)
case 'double'
   flist  = features(f);
   if length(f.Type)==0 & ~isfield(f.Type,'index')
      f.Type = DatumDisplay(f,flist(Type));
   else
      f.Type = [f.Type DatumDisplay(f,flist(Type))];
   end
   if nargin==4
      f.Limits= [f.Limits,Limits];
   else
      f.Limits= [f.Limits repmat([-Inf Inf]',1,length(Value)) ];
   end
case 'char'
   f.Type.Function= [f.Type.Function cellstr(Type)];
   f.Type.delG= [f.Type.delG cellstr(delG)];
   f.Type.Display= [f.Type.Display cellstr(Value)];
case 'cell'
   f.Type.Function= [f.Function Type];
   f.Type.delG= [f.delG delG];
   f.Type.Display= [f.Type.Display Value];
end

f.Type= DatumDisplay(f,f.Type);

f= EvalDelG(f);
