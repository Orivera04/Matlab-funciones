function isE = isEstimatedParam(this)
% Returns true for parameters estimated in at least 
% one of the estimations.

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:20 $
Np = length(this.AllParameters);
isE = false(Np,1);
for ct=1:length(this.Waves)
   % Loop over estimation views
   % RE: Wave's list of parameters can be a strict subset of the global list
   w = this.Waves(ct);
   Estimation = w.DataSrc.Estimation;
   GlobalParams = Estimation.Parameters;
   LocalParams = w.DataSrc.Parameters;
   RowIndex = w.RowIndex;
   for ctp=1:length(LocalParams)
      idxp = RowIndex(ctp);
      isE(idxp) = isE(idxp) || any(GlobalParams(idxp).Estimated(:));
   end
end
