function stationtest(type)

%
%Demonstration of the function stationary
%
%Inputting "type" as 'max','min' or 'both' will show the function below plotted, with the required stationary 
%points shown as crosses
%

x=-10*pi:pi/1000:10*pi;
y=sin(x).*exp(-(x+10*pi)/10);

[ind]=stationary(x,y,type);

plot(x,y,x(ind),y(ind),'X')

