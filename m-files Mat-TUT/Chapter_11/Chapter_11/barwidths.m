% Subplot to show varying bar widths
 
year = 2007:2011;
pop = [0.9  1.4  1.7  1.3  1.8];
 
for i = 1:4
    subplot(1,4,i)
    % width will be 0.6, 0.8, 1, 1.2
    barh(year,pop,0.4+i*.2)
    title(sprintf('Width = %.1f',0.4+i*.2))
    xlabel('Population')
    ylabel('Year')
end
