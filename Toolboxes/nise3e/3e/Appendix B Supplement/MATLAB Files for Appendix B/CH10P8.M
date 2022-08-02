% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch10p8) Example 10.18: We can use MATLAB and frequency response methods to 
% determine experimentally a transfer function from frequency response data. By 
% determining simple component transfer functions and then successively subtracting 
% their frequency response, we can approximate the complete transfer function. 
% Let us look at Example 10.18 in the text and use MATLAB for a portion of the 
% problem. You can complete the program for practice. For this problem, we 
% generate the original frequency response plot via a transfer function. Normally, 
% the data for the original frequency response plot would be tabular and the 
% program would begin at the step:[M0,P0] = bode(G0,w) where the tabular 
% data is generated. In other words, in a real application, the data would consist 
% of column vectors MO, PO, and w'. 

'(ch10p8) Example 10.18'            % Display label.
clf                                 % Clear graph on screen.
hold off                            % Turn graph hold off.
% Generate the experimental Bode plots for G0(s)=numg0/deng0 i.e. M0,P0.
numg0=70*[1 20];                    % Define numerator of G0(s).
deng0=conv([1 7],[1 2 25]);         % Partially define denominator of 
                                    % G0(s).
deng0=conv(deng0,[1 70]);           % Complete the denominator of G0(s).
G0=tf(numg0,deng0);                 % Create G0(s).
w=1:0.5:1000;                       % Let 1<w<1000 in steps of 0.5.
[M0,P0]=bode(G0,w);                 % Generate the tabular data.
[20*log10(M0(:,:))',P0(:,:)',w'];   % Convert magnitude data to dB.
grid on                             % Turn on grid for Bode plot.
bode(G0,w)                          % Generate a Bode plot.
title('Experimental')               % Add title.
pause
clf                                 % Clear graph.
% Estimate a component part of the transfer function as 
% G1(s)=25/(s^2+2*0.22*5s+5^2) and subtract it from the experimental
% frequency response.
numg1=5^2;                          % Define numerator of G1(s).
deng1=[1 2*0.22*5 5^2];             % Define denominator of G1(s).
'First estimate'                    % Display label.
G1=tf(numg1,deng1)                  % Create and display G1(s).
[M1,P1]=bode(G1,w);                 % Generate Bode data for G1(s).
M2=20*log10(M0(:,:))-20*log10(M1(:,:));		
                                    % Subtract Bode magnitude data of G1
                                    % from original magnitude data.
P2=P0(:,:)-P1(:,:);                 % Subtract Bode phase data of G1 from  
                                    % original phase data.
subplot(2,1,1)                      % Divide plot area in two for 
                                    % magnitude plot.
semilogx(w(:,:),M2)                 % Plot magnitude response after 
                                    % subtracting.
grid on                             % Turn on grid for magnitude plot.
xlabel('Frequency (rad/sec)')       % Add x-axis label.
ylabel('Gain dB')                   % Add y-axis label.
subplot(2,1,2)                      % Divide plot area in two for phase  
                                    % plot.
semilogx(w,P2)                      % Plot the phase response after 
                                    % subtracting.
grid on                             % Turn on grid for phase plot.
title('Experimental Minus 25/(s^2+2*0.22*5s+5^2)')
                                    % Add title.
xlabel('Frequency (rad/sec)')       % Add x-axis label.
ylabel('Phase deg')                 % Add y-axis label.
'This completes a portion of Example 10.18.' 
'The student should continue the program for practice.'
