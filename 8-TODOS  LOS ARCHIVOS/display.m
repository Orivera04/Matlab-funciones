function display(au)
% AUDIO/DISPLAY		Displays Information about an audio object
% 
% 
% Usage Example : au
% 
% 
% Note     :
% See also 

% Uses :

% Change History :
% Date		Time		Prog	Note
% 12-Jan-1999	 2:25 PM	ATC	Created under MATLAB 5.2.0.3084

% ATC = Ali Taylan Cemgil,
% SNN - University of Nijmegen, Department of Medical Physics and Biophysics
% e-mail : cemgil@mbfys.kun.nl 

fprintf(1,'\n%s\n\n',au.Filename);

formatstr = str2mat('PCM','<Unknown>','<Unknown>','<Unknown>','<Unknown>','CCITT-A','CCITT-mu');

fprintf(1,'Data Format        : %s\n',formatstr(au.Format.DataFormat,:));
fprintf(1,'Size (on Disk)     : %.0f KBytes\n',au.Format.SizeInBytes/1024);
fprintf(1,'Size (in Workspace): %.0f KBytes\n',au.Format.Length*au.Format.Channel*8/1024)
fprintf(1,'Length             : %d Samples\n',au.Format.Length);
fprintf(1,'Time               : %.2f Seconds\n', au.Format.Length/au.Format.Fs);
fprintf(1,'Fs                 : %d Hz\n', au.Format.Fs);
fprintf(1,'Channels           : %d\n', au.Format.Channel);
%%fprintf(1,'Average bytes/sec : %d\n',au.Format.AverageBytes);
fprintf(1,'Block Alignment    : %d\n',au.Format.BlockAlignment);
fprintf(1,'Bits/Sample        : %d\n',au.Format.BitsPerSample);



