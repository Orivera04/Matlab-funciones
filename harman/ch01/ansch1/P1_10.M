% P1_10.M Plot the ratio of area to perimeter
%   calls triratio(base,height) to compute ratio
clear    % Clear workspace variables
clf      %  and figures
base=[0:100];
height=10
y=triratio(base,height);
x=base./height;
plot(x,y)
grid
ylabel('Area/Perimeter')
xlabel('Base/Height')
