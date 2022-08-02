% Reads sales figures for 2 divisions of a company one
% line at a time as strings, and plots the data

fid = fopen('ab11.dat');
if fid == -1
    disp('File open not successful')
else
 
    for i = 1:4
       % Every line is of the form A#B#; this separates
       % the characters and converts the #’s to actual
       % numbers
       aline = fgetl(fid);
       aline = aline(2:length(aline));
       [compa rest] = strtok(aline,'B');
       compa = str2num(compa);
       compb = rest(2:length(rest));
       compb = str2num(compb);
 
       % Data from every line is in a separate subplot
       subplot(1,4,i)
       bar([compa,compb])
       set(gca, 'XTickLabel', {'A', 'B'})
       axis([0 3 0 8]) 
	  ylabel('Sales (millions)')
       title(sprintf('Quarter %d',i))
   end
   closeresult = fclose(fid);
   if closeresult ~= 0
       disp('File close not successful')
   end
end
