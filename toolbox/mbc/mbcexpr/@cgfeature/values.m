function out = values(SF)
%VALUES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:54 $

% For a SubFeature SF, values returns a structure out with two fields:
%         out.equation - pointers values in the equation expression of SF
%         out.model - pointers values in the model expression of SF

eq = SF.eqexpr;
mod = SF.modelexpr;
op = SF.oppoint;
if isempty(eq);
   out.equation = [];
else
   V = getptrs(eq.info);
   U = [];
   for i = 1:length(V)
      if isa(V(i).info,'cgvariable')
         U = [U;V(i)];
      end
   end
   out.equation = U;
end


if isempty(mod);
   out.model = [];
else
   if isa(mod.info,'cgmodexpr')
      out.model = mod.get('ptrlist');
   else
      V = getptrs(mod.info);
      U = [];
      for i = 1:length(V)
         if isa(V(i).info,'cgmodexpr')
            U = [U V(i).get('ptrlist')];
         end
      end
      W = [U(1)];
      for k = 2:length(U)
         c = 0;
         for j = 1:k-1
            if isequal(U(j),U(k))
               c = 1;
            end
         end
         if c==0
            W = [W U(k)];
         end
      end
      out.model = W;
   end
end

if isempty(op);
   out.oppoint = [];
else
   V = getptrs(op.info);
   U = [];
   for i = 1:length(V)
      if isa(V(i).info,'cgvariable')
         U = [U;V(i)];
      end
   end
   out.oppoint = U;
end














