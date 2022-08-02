function theMeasure=dcos(measureInDegrees)
%find the cosign of the specifyed number when that number is in degrees
%this function takes one argument, a real number
%it finds the cosign for this number assuming the number is in degrees
inRads=measureInDegrees/180*pi;
%convert from degrees to radians
%now find the sign in radians and return it
theMeasure=cos(inRads);
