Thickness=0.1;
ID=8;
Pressure=50;
HoopStress=Pressure*(ID/2)/Thickness
Pressure=400;
Thickness=25;
Radius=220;
StressHoop=Pressure*Radius/Thickness
StressAxial=Pressure*Radius/(2*Thickness)
StressState=[StressAxial StressHoop 0];
mohrs (StressState, 'plane stress')
