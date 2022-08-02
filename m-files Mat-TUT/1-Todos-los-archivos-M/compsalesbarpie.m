% Reads sales figures and plots as a bar chart and a pie chart

fid = fopen('compsales.dat');
 
if fid == -1
    disp('File open not successful')
else
   % Use textscan to read the numbers and division codes  
   % into separate elements in a cell array
   filecell = textscan(fid,'%f %s');
   % plot the bar chart with the division codes on the x ticks
   subplot(1,2,1)
   bar(filecell{1})
   xlabel('Division')
   ylabel('Sales (millions)')
   set(gca, 'XTickLabel', filecell{2})
   % plot the pie chart with the division codes as labels
   subplot(1,2,2)
   pie(filecell{1}, filecell{2})
   title('Sales in millions by division')
   
   closeresult = fclose(fid);   
   if closeresult ~= 0
       disp('File close not successful')
   end
end
