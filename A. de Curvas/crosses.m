 function [VALUE] = crosses(DATA,INDEX);
% CROSSES = Data set interpolation for fractional index values
%
%function [VALUE] = crosses(DATA,INDEX);
%
% RETURNS : The DATA VALUE(s) at the linearly interpolated INDEX(es)
%
% SEE ALSO : CROSSING
 DATA = DATA(:); INDEX = INDEX(:);
 int = floor(INDEX); dec = INDEX-int;
 VALUE = DATA(int)+dec.*(DATA((dec ~= 0)+int)-DATA(int));
