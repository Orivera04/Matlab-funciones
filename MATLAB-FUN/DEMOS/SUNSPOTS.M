%SUNSPOTS The answer is 11.08, what is the question?

%	CBM+LS, 8-27-92.
%	This Expo demo adapted by ...
%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

% The demo data file, sunspot.dat, contains the data.
load sunspot.dat
year = sunspot(:,1);
wolfer = sunspot(:,2);

if ssinit(figNumber), 
    % Plot Wolfer number versus year.
    plot(year,wolfer) 
    title('Sunspot Data')
    drawnow;

    str= ...                                                         
    [' Press the "Start" button to see a demonstration of the '  
     ' FFT function in MATLAB used to analyze the variations  '  
     ' in sunspot activity over the last 300 years.           '];
    ssdisp(figNumber,str);                                           
    if figNumber, return; end
end

% Beginning of the demo ==================

% You are probably aware that sunspot activity is cyclical,
% reaching a maximum about every 11 years.  Let's confirm that.
% We will analyze a quantity known as the Wolfer number, which
% measures both number and size of sunspots, and which astronomers
% have tabulated for almost 300 years.
%
% See chapter 11 of "Numerical Methods and Software, by
% D. Kahaner, C. Moler and S. Nash, Prentice-Hall, 1989, 
% for a more detailed discussion.

str= ...                                                              
    [' You are probably aware that sunspot activity is cyclical,   '  
     ' reaching a maximum about every 11 years. Let''s confirm that.'  
     ' Here is a plot of a quantity called the Wolfer number, which'  
     ' measures both number and size of sunspots. Astronomers      '  
     ' have tabulated this number for almost 300 years.            '  
     '                                                             '  
     ' >> load sunspot.dat                                         '  
     ' >> year=sunspot(:,1); wolfer=sunspot(:,2);                  '  
     ' >> plot(year,wolfer)                                        '  
     ' >> title(''Sunspot Data'')                                    '];
ssdisp(figNumber,str);                                                

if sspause(figNumber), return; end;

str= ...                                                                
    [' Here is a closer look at the first 50 years.                  '  
     '                                                               '  
     ' >> plot(year(1:50),wolfer(1:50),year(1:50),wolfer(1:50),''go'');'];
ssdisp(figNumber,str);                                                  

plot(year(1:50),wolfer(1:50),year(1:50),wolfer(1:50),'go');

if sspause(figNumber), return; end;

str= ...                                                                 
    [' The fundamental tool of signal processing is the FFT, or fast  '  
     ' Finite Fourier Transform. To take the FFT of the sunspot data  '  
     ' we would type                                                  '  
     '                                                                '  
     ' >> Y = fft(wolfer);                                            '  
     '                                                                '  
     ' The first component of Y, Y(1), is simply the sum of the data, '  
     ' and can be removed.                                            '  
     '                                                                '  
     ' >> Y(1)=[ ];                                                   '];
ssdisp(figNumber,str);                                                   

if sspause(figNumber), return; end;

Y = fft(wolfer);
n = length(Y);

% The first component, Y(1), is simply the sum of the data
% and can be removed.
Y(1) = [];

plot(Y,'co')
title('Fourier Coefficients in the Complex Plane');
xlabel('Real Axis');
ylabel('Imaginary Axis');
set(gca,'YTick',[],'XTick',[]);

str= ...                                                                   
    [' A graph of the distribution of the Fourier coefficients (given   '  
     ' by Y) in the complex plane is pretty, but difficult to interpret.'  
     '                                                                  '  
     ' >> plot(Y,''co'')                                                  '  
     ' >> title(''Fourier Coefficients in the Complex Plane'');           '  
     ' >> xlabel(''Real Axis'');                                          '  
     ' >> ylabel(''Imaginary Axis'');                                     '  
     '                                                                  '  
     ' We need a more useful way of examining the data in Y.            '];
ssdisp(figNumber,str);                                                     

if sspause(figNumber), return; end;

str= ...                                                          
    [' The complex magnitude squared of Y is called the power, '  
     ' and a plot of power versus frequency is a "periodogram".'  
     '                                                         '  
     ' >> n=length(Y);                                         '  
     ' >> power = abs(Y(1:n/2)).^2;                            '  
     ' >> nyquist = 1/2;                                       '  
     ' >> freq = (1:n/2)/(n/2)*nyquist;                        '  
     ' >> plot(freq,power)                                     '  
     ' >> xlabel(''cycles/year'')                                '  
     ' >> title(''Periodogram'')                                 '  
     '                                                         '];
ssdisp(figNumber,str);                                            

power = abs(Y(1:n/2)).^2;
nyquist = 1/2;
freq = (1:n/2)/(n/2)*nyquist;

plot(freq,power)
xlabel('cycles/year')
title('Periodogram')

if sspause(figNumber), return; end;

str= ...                                                           
    [' Zoom in on the first 40 components for a closer look.    '  
     '                                                          '  
     ' >> plot(freq(1:40),power(1:40))                          '  
     ' >> xlabel(''cycles/year'')                                 '  
     '                                                          '  
     ' The scale in cycles/year is somewhat inconvenient. We can'  
     ' plot in years/cycle and esimate what one cycle is.       '];
ssdisp(figNumber,str);                                             

plot(freq(1:40),power(1:40))
xlabel('cycles/year')

if sspause(figNumber), return; end;

str= ...                                                               
    [' Here we plot power versus period for convenience (where      '  
     ' period=1./freq). As expected, there is a very prominent cycle'  
     ' with a length of about 11 years.                             '  
     '                                                              '  
     ' >> period=1./freq;                                           '  
     ' >> plot(period,power);                                       '  
     ' >> ylabel(''Power'');                                          '  
     ' >> xlabel(''Period (Years/Cycle)'');                           '];
ssdisp(figNumber,str);                                                 

period=1./freq;
plot(period,power);
axis([0 40 0 2e+7]);
ylabel('Power');
xlabel('Period (Years/Cycle)');

if sspause(figNumber), return; end;

hold on;
index=find(power==max(power));
mainPeriodStr=num2str(period(index));
plot(period(index),power(index),'r.', ...
    'MarkerSize',25,'EraseMode','none');
text(period(index)+2,power(index),['Period = ',mainPeriodStr], ...
    'EraseMode','none');
hold off;

str= ...                                                                  
    [' Finally, we can fix the cycle length a little more precisely, as'  
     ' shown in this plot.                                             '  
     '                                                                 '  
     ' >> index=find(power==max(power));                               '  
     ' >> period(index)                                                '  
     ' ans =                                                           '  
     '           11.0769                                               '];
ssdisp(figNumber,str);                                                    

% End of the demo ========================
