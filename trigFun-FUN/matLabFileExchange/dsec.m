function theSecant=dsec(measureInDegrees)
%finds the secant in degrees for the angle you pass in
%pass in an angle in degrees,
%this function converts it to radians then returns the secant
inRads=measureInDegrees*pi/180;
theSecant=sec(inRads);
