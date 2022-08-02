function z=fun(b)
% Function whose root gives the parameter b
% in the World Class Sprints model.

global Time1 Dist1 Time2 Dist2
% Global values Time1,Dist1 and Time2,Dist2 are
% (time, distance) observed data pairs for a sprint.

z= Dist1/Dist2 - ...
 ( Time1-b+b*exp(-Time1/b) )/( Time2-b+b*exp(-Time2/b) );