function un=unitconvertermultpow(mult,add)
% 
str.multiplier=mult;
str.add=add;
p=unitconverter('mult and add');
un=class(str,'unitconvertermultadd',p);