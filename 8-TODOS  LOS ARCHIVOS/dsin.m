function theSign=dsin(measureInDegrees)
%finds the sign with an angle passed in degrees
%pass in an angle in degrees,
%and this automaticly does the conversion to radians, then returns the sign of that angle
inRads=measureInDegrees/180*pi;
%change from degrees to radians, then find the sign and return
theSign=sin(inRads);
