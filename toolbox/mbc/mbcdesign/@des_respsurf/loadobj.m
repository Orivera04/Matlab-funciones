function desout=loadobj(desin)
% LOADOBJ   Object loading function
%
%   B=LOADOBJ(A) is called when a design object
%   is loaded.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:47 $

% Created 16/2/2000


if isa(desin,'des_respsurf');
   % loading worked ok anyway
   desout=desin;
else
   % do version switching
   % new features are cumulatively added to this section
   if desin.version<=1
      % version 1 -> 1.1 additions
      % need optimisedon fields
      desin.optimisedon.cand=-1;
      desin.optimisedon.design=-1;
      desin.optimisedon.model=-1;
   end
   
   if desin.version<=1.1
      % version 1.1 ->1.2
      desin.preferredoptimiser='v-optimal';
   end
   des=desin.xregdesign;
   desin=rmfield(desin,'xregdesign');
   desout=des_respsurf(desin,des);
end
