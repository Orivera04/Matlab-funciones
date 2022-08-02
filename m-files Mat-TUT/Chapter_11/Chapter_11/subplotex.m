% Demonstrates subplot using a for loop
for i = 1:2
    x = linspace(0,2*pi,10*i);
    y = sin(x);
    subplot(1,2,i)
    plot(x,y,'ko')
    xlabel('x')
    ylabel('sin(x)')
    title(sprintf('%d Points',10*i))
end
