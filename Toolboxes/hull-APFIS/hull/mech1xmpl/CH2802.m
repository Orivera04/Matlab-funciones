ID=0.55; %meters
Thickness=0.002; %meters
Height=0.90; %meters
Mass=68; %kilograms
Pressure=4500; %Pascals
Gravity=-9.81; % meters/s^2
Area=obeam(ID+2*Thickness,ID,'area');
Weight=Gravity*Mass;
StressNormal=Weight/Area;
StressAxial=Pressure*(ID/2)/(2*Thickness);
StressHoop=Pressure*(ID/2)/Thickness;
StressState=[StressHoop, StressAxial+StressNormal 0];
mohrs (StressState, 'plane stress')
