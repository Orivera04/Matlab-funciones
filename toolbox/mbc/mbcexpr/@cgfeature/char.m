function out = char(SF)
%CHAR Return string description of object
% 
%  STR = CHAR(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:10:30 $

% char function for SubFeatures. Returns chars of equation and model

eq = SF.eqexpr;
if ~isempty(eq)
   if isa(eq.info, 'cgfeature')
      % features return a structure!
      featchar = char(eq.info);
      out.equation = featchar.equation; 
   else
      % other exprs return a proper char
      out.equation = char(eq.info);
   end
else
   out.equation = '';
end
mod = SF.modelexpr;
if ~isempty(mod)
   out.model = char(mod.info);
else 
   out.model = '';
end
op = SF.oppoint;
if ~isempty(op)
   out.oppoint = char(op.info);
else 
   out.oppoint = '';
end
