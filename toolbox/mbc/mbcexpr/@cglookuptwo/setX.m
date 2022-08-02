function LT = setX(LT,p,q)
%SETX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:12:38 $

% LT = setX(LT,p,q);
% 
% Sets the x arguement in the LUT LT to the xregpointer q.
% It will also update the FList in both the new X arguement expression
% and if applicable, the old X arguement expression. p should be a xregpointer to
% THIS Lookup table, q should be a xregpointer to the new X arguement.

if ~isa(p,'xregpointer') | ~isa(q,'xregpointer')
   error('Must have xregpointers as arguments')
end

% first check that p points to LT

PT = p.info;

if ~( PT == LT )
   error('First xregpointer must point to the Look up table, whose arguments you are changing')
end

if ~isa(q.info,'cgnormaliser')
   error('cglookuptwo requires a normalizer as an input');
end

r = LT.Xexpr;
s = LT.Yexpr;
if ~isempty(r);
   r.info = UpdateFlist(r.info,p,0);
end
if isequal(r,s) & ~isempty(s)
   s.info = UpdateFlist(s.info,p,1);
   % this checks to see if x and y inputs were the same, if they were, then 
   % any reference to this table will have been wiped from the Flist of
   % the normaliser associated with r (previously it would have appeared twice)
   % so we need to reinstall it once.
end


q.info  = UpdateFlist(q.info,p,1);

LT.Xexpr = q;




