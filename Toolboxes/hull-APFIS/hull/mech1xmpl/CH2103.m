Lengths=[0.7 0.5 0.5 0.5]; %meters
Area=[0.03 0.03 0.06 0.03].^2*pi; %getting area from radii
Youngs=[210 180 210 210]*1e9; %Pascals
DeltaL=0.008;%meters
%%%%% End Set up Variables %%%%%
Forces=DeltaL*Youngs.*Area./Lengths;
af=sum(Forces)
Stresses=Forces./Area
