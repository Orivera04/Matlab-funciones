%  alt_5a.m
%  calls scattermatrixc

load environmental


data = [SolarRadiation Temperature WindSpeed];
label = {'Solar Radiation' 'Temperature' 'Wind Speed'};

z = (Ozone).^(1/3);

scattermatrixc(data,z,label)