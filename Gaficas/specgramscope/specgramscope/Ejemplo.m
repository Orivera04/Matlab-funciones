% Example
         %% Initialize data
         Fs = 16384;
         Nfft = 2048;
         t = (0:1:Nfft-1)'/Fs;
         fo = logspace(3.5,3.7);         % Range of fundamental frequencies
         s1 = sin(2*pi*t*fo) + .1*rand(Nfft,length(fo));
 
 
         %% Initialize scope
         specgramscope(Fs,Nfft,30);
         view([103 30])
 
         %% Update scope
         for ii = 1:length(fo)
             specgramscope(s1(:,ii));
             drawnow;pause(.01);
         end;