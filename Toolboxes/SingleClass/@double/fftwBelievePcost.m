%FFTW planner flag -- believe CPU cycle counter.
%
%  Attention: disables consistency check against
%             slow clock and may mislead planner
%             if interrupted.
%
function o=fftwBelievePcost
o=256;
