function xfocus = getfocus(this, Experiments)
% Computes time range for each column (experiment)

%  Author(s): P. Gahinet
%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:12 $

nexp = length(Experiments);
xfocus = cell(1,nexp);
for ct=1:nexp
   e = Experiments(ct);
   tmin = Inf;
   tmax = -Inf;
   for cto=1:length(e.OutputData)
      tmin = min(tmin,e.OutputData(cto).Tstart);
      tmax = max(tmax,e.OutputData(cto).Tstop);
   end
   if all(isfinite([tmin tmax]))
     xfocus{ct} = [tmin tmax];
   else
     xfocus{ct} = [0 10];
   end
end
