% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch4p2) Example 4.8: We can use MATLAB to obtain system step responses. These 
% responses are particularly valuable when the system is not a pure two-pole system 
% and has additional poles or zeros. We can obtain a plot of the step response of a 
% transfer function, T(s) = num/den, using the command step(T), where T is an LTI 
% transfer-function object. Multiple plots also can be obtained using step(T1,T2,. . . ).
%
% Information about the plots obtained with step(T) can be found by left-clicking the 
% mouse on the curve. You can find the curve's label, as well as the coordinates of 
% the point on which you clicked. Right clicking on a curve emphasizes and identifies 
% the curve. Right clicking away from a curve brings up a menu. From this menu you can
% select (1) system responses to be displayed, (2) response characteristics to be 
% displayed, (3) choices for zooming, and (4) choice for grid on or off. If you select 
% a response characteristic, an appropriate point is displayed on the plot. Clicking on 
% the point reveals measurements of the selected characteristic.
%
% If we add the left-hand side, [y,t] = step(T), we create vectors containing the 
% plot's points, where y is the output vector and t is the time vector. For this case, 
% a plot is not made until the plot(t,y) command is given, where we assume we want to 
% plot the output(y) vs. time(t). We can label the plot, the x axis, and the y axis 
% with title('ab'), xlabel('ab'), and ylabel('ab'), respectively. The command 'clf' 
% clears the graph prior to plotting. Finally, text can be placed anywhere on the graph 
% using the command text(X,Y,'text'), where (X,Y) are the graph coordinates where 'text' 
% will be displayed. Let us look at Example 4.8 in the text.

'(ch4p2) Example 4.8'               % Display label.
'Test Run'                          % Display label.
clf                                 % Clear graph.
numt1=[24.542];                     % Define numerator of T1.
dent1=[1 4 24.542];                 % Define denominator of T1.
'T1(s)'                             % Display label.
T1=tf(numt1,dent1)                  % Create and display T1(s).
step(T1)                            % Run a demonstration step response  
                                    % plot.
title('Test Run of T1(s)')          % Add title to graph.
pause
'Complete Run'                      % Display label.
[y1,t1]=step(T1);                   % Run step response of T1 and collect 
                                    % points.
numt2=[245.42];                     % Define numerator of T2.
p1=[1 10];                          % Define (s+10) in denominator of T2.
p2=[1 4 24.542];                    % Define (s^2+4s+24.542) in 
                                    % denominator of T2.
dent2=conv(p1,p2);                  % Multiply (s+10)(s^2+4s+24.542) for 
                                    % denominator of T2.
'T2(s)'                             % Display label.
T2=tf(numt2,dent2)                  % Create and display T2.	
[y2,t2]=step(T2);                   % Run step response of T2 and collect 
                                    % points.
numt3=[73.626];                     % Define numerator of T3.
p3=[1 3];                           % Define (s+3) in denominator of T3.
dent3=conv(p3,p2);                  % Multiply (s+3)(s^2+4s+24.542) for 
                                    % denominator of T3.
'T3(s)'                             % Display label.
T3=tf(numt3,dent3)                  % Create and display T3.
[y3,t3]=step(T3);                   % Run step response of T3 and collect 
                                    % points.
clf                                 % Clear graph.
plot(t1,y1,t2,y2,t3,y3)             % Plot acquired points with all three  
                                    % plots on one graph.
title('Step Responses of T1(s),T2(s),and T3(s)')
                                    % Add title to graph.
xlabel('Time(seconds)')             % Add time axis label.
ylabel('Normalized Response')       % Add response axis label.
text(0.7,0.7,'c3(t)')               % Label step response of T1.
text(0.7,1.1,'c2(t)')               % Label step response of T2.
text(0.5,1.3,'c1(t)')               % Label step response of T3.
pause
step(T1,T2,T3)                      % Use alternate method of plotting step 
                                    % responses.
title('Step Responses of T1(s),T2(s),and T3(s)')
                                    % Add title to graph.
