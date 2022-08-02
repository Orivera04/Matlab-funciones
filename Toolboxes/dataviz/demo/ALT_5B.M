%  alt_5b.m

load environmental


data = [SolarRadiation Temperature WindSpeed];
label = {'Solar Radiation' 'Temperature' 'Wind Speed'};

z = (Ozone).^(1/3);
response = z;

%  make color map index
nc = 16;
offset = 1;
c = response-min(response);
c = round((nc-1-2*offset)*c/max(c)+1+offset);

scatter3(Temperature,WindSpeed,SolarRadiation,6,c,'filled')
box on

colormap(hot)
myMap = colormap;
colormap(flipud(myMap))

view(-50,15)
xlabel('Temperature')
ylabel('Wind Speed')
zlabel('Radiation')
title('Ozone')

colorbar
