function un=unitconvertermultpow(mult,powr)
% 
str.multiplier=mult;
str.power=powr;
p=unitconverter('mult and power');
un=class(str,'unitconvertermultpow',p);