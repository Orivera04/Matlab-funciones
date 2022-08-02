function out = loadobj(in)
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:49 $

if isa(in , 'cgfeature')
   out = in;
else
   out = cgfeature;
   out.cgexpr = in.cgexpr;
   if isfield(in , 'history')
      out.history = in.history;
   end
   if isfield(in , 'modelexpr')
      out.modelexpr = in.modelexpr;
   end
   if isfield(in , 'eqexpr')
      out.eqexpr = in.eqexpr;
   end
   if isfield(in , 'oppoint')
      out.oppoint = in.oppoint;
   end
   if isfield(in , 'om')
      out.om = in.om;
   end
end

