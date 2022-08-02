% Reads from a file one line at a time using fgetl
% Each line has a number and a character
% The script separates and prints them

% Open the file and check for success
fid = fopen('subjexp.dat');
if fid == -1
    disp('File open not successful')
else
   while feof(fid) == 0
       aline = fgetl(fid);
	  % Separate each line into the number and character
	  %  code and convert to a number before printing
       [num charcode] = strtok(aline);
       fprintf('%.2f %s\n', str2num(num), charcode)
   end

   % Check the file close for success
   closeresult = fclose(fid);
   if closeresult == 0
       disp('File close successful')
   else
       disp('File close not successful')
   end
 end
