%  book_5_1.m
%  calls scattermatrix

load environmental

nseries = 4;

data = [(Ozone).^(1/3) SolarRadiation Temperature WindSpeed];
label = {'CubeRoot Ozone' 'Solar Radiation' 'Temperature' 'Wind Speed'};

scattermatrix(data,label)
