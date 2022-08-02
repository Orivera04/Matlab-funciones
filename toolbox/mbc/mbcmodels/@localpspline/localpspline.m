function ps= localpspline(order,Vals,Type)
% localpspline Constructor
% 
%  ps= localpspline(order,Vals,Type)
%    order= [high low]

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:41:22 $




ps.version=1;
if nargin==0;
   order = [2 3];
end

if isa(order,'struct')
   order.version= ps.version;
   ps= order;
   if ~isfield(ps,'localmod')
      LocMod= localmod;
   else
      LocMod= localmod(ps.localmod);
      ps= mv_rmfield(ps,'localmod');
   end
   m = ps.xregmodel;
   if ~isa(m,'xregmodel');
      m= xregmodel(m);
   end
   ps= mv_rmfield(ps,'xregmodel');
elseif isa(order,'localpspline')
   ps=order;
   return
else
   ps.knot     = 0;
   ps.order    = order;
   ps.polylow  = [ones(1,order(2)-1) 0 1];
   ps.polyhigh = [ones(1,order(1)-1) 0 1];
   ps.Store=[];
   m= xregmodel;
   LocMod= localmod;
end
ps=class(ps,'localpspline',LocMod,m);

if nargin <=1
   [Feats,Types,Vals]= features(ps);
end
if ~isempty(Vals)
   ps=AddFeat(ps,Vals,Types);
end
