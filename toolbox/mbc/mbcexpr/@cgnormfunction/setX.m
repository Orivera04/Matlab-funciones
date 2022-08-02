function LT = setX(LT,p,q)
%SETX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:15:08 $

% Sets the x argument in the LUT LT to the xregxregpointer q.
% It will also update the FList in both the new X argument expression
% and if applicable, the old X arguement expression. p should be a xregpointer to
% THIS Lookup table, q should be a xregpointer to the new X argument.

if ~isa(p,'xregpointer') | ~isa(q,'xregpointer')
   error('Must have xregpointers as arguments')
end

% first check that p points to LT

PT = p.info;

if ~isequal(PT.Values,LT.Values)
   error('First xregpointer must point to the look up table, whose arguments you are changing')
end

if ~isa(q.info,'cgnormaliser')
   error('cgnormfunction requires a normalizer as an input');
end

r = LT.Xexpr;
if ~isempty(r);
   r.info = UpdateFlist(r.info,p,0);
end

q.info  = UpdateFlist(q.info,p,1);


LT.Xexpr = q;
V = get(q.info,'values');
%m = max(V);
%LT.Breakpoints = [0:m]';





