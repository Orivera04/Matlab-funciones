%  alt_5_2.m

load environmental

nseries = 4;

data = [(Ozone).^(1/3) SolarRadiation Temperature WindSpeed];
label = {'Cube Root Ozone' 'Solar Radiation' 'Temperature' 'Wind Speed'};

x1 = SolarRadiation;
x2 = Temperature;
x3 = WindSpeed;
z = (Ozone).^(1/3);

%  make color map index
nc = 20;
offset = 1;
c = z-min(z);
c = round((nc-1-2*offset)*c/max(c)+1+offset);


subplot(2,2,1)
scatter(x1,x2,6,c,'filled')
box on
ylabel('Temperature')
subplot(2,2,2)
scatter(x3,x2,6,c,'filled')
box on
xlabel('WindSpeed')
subplot(2,2,3)
scatter(x1,x3,6,c,'filled')
box on
xlabel('Solar Radiation')

colormap(hot)
myMap = colormap;
colormap(flipud(myMap))
