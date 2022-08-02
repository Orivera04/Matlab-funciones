function p=localpoly(a,vals,types);
% LOCALPOLY Polynomial class constructor

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:40:32 $



p.version=3;
if nargin==0
   ml = xreglinear([-1 -2 -1],1);
   LocMod= localmod;
elseif isa(a,'localpoly')
   p=a;
   return
elseif isa(a,'struct')
	[LocMod,ml]= i_Update(a);
else
   ml = xreglinear(a,1);
   LocMod= localmod;
end   
p=class(p,'localpoly',LocMod,ml);

if nargin<=1
   n=order(p)+1;
   vals=zeros(n,1);
   types=[n 1:n-1];
end

if ~isempty(vals)
   p=AddFeat(p,vals,types);
end


function [LocMod,ml]= i_Update(a);

if ~isfield(a,'localmod')
	LocMod= localmod;
else
	LocMod= localmod(a.localmod);
end
if ~isfield(a,'xreglinear')
	ml= xreglinear;
else
	ml= xreglinear(a.xreglinear); 
end
