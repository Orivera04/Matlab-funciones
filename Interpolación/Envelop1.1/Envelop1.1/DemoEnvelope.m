%DEMOENVELOPE shows how to use function envelope to obtain the 
%   upper/down envelope of a given data and plot the envelope.
%
%   See also EVELOPE

%   Designed by: Lei Wang, <WangLeiBox@hotmail.com>, 11-Mar-2003.
%   Last Revision: 21-Mar-2003.
%   Dept. Mechanical & Aerospace Engineering, NC State University.
% $Revision: 1.1 $  $Date: 3/21/2003 10:38 AM $

clc;

% Load a signal waveform
%--------------------------------------------
load data.txt data;
t = data(:,1); % time series
y = data(:,2); % signal data
figure(1);
plot(t,y,'b-'); 
title('The original signal waveform','FontSize',18);



% Call function envelope to 
% obtain the envelope data
%--------------------------------------------
[up,down] = envelope(t,y,'linear');



% Show the envelope alone
%--------------------------------------------
figure(2)
plot(t,up); hold on;
plot(t,down);
title('The envelope of the given signal data','FontSize',18);
hold off;



% Show the original signal and its envelope
%--------------------------------------------
figure(3)
plot(t,y,'g-'); hold on;
plot(t,up,'r-.');
plot(t,down,'r-.');
title('The envelope vs the given signal data','FontSize',18);
hold off;

