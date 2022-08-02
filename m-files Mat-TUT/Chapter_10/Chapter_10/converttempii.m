function varargout = converttempii(degreesC)
% converttempii converts temperature in degrees C
% to degrees F and maybe also K
% Format: converttempii(C temperature)

n = nargout;
varargout{1} = 9/5*degreesC + 32;
if n == 2
    varargout{2} = degreesC + 273.15;
end
end
