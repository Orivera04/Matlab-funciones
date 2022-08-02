fid = fopen('xypoints.dat');
 
if fid == -1
    disp('File open not successful')
else
   % Create x and y vectors for the data points
   % This part will be filled in using different methods
   

   % Plot the points
   plot(x,y,'k*')
   xlabel('x')
   ylabel('y')
   
   % Close the file
   closeresult = fclose(fid);   
   if closeresult == 0
       disp('File close successful')
   else
       disp('File close not successful')
   end
end
