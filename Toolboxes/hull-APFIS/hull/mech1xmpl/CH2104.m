clear %undefining all of the variables
clc %clearing the command window of text
Length=[0.7 0.5 0.5 0.5];
Area=[0.03 0.03 0.06 0.03].^2*pi; %getting area from radii
Youngs=[210 180 210 210]*1e9;
af=6.2430e+07;
Stiffness=Length./(Area.*Youngs);
Percentage=(1./Stiffness)./sum(1./Stiffness);
Forces=Percentage*af
Deflectons=Forces.*Length./(Area.*Youngs)
DeltaL=Deflectons(1)
