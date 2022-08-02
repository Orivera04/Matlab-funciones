% Reads data from a file using textscan
fid = fopen('subjexp.dat');

if fid == -1
    disp('File open not successful')
else
   % Reads numbers and characters into separate elements
   % in a cell array
   subjdata = textscan(fid,'%f %c');
   len = length(subjdata{1});
   for i= 1:len
       fprintf('%.1f %c\n',subjdata{1}(i),subjdata{2}(i))
   end   
 
   closeresult = fclose(fid);   
   if closeresult == 0
       disp('File close successful')
   else
       disp('File close not successful')
   end
end
