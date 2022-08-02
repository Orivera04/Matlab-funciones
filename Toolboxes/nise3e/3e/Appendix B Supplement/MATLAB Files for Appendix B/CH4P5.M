% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch4p5) UFSS Case Study: As a final example, let us use MATLAB to do the UFSS 
% Case Study in the text (Johnson, 1980). We introduce table lookup to find the 
% rise time. Using the table1(tab,x) command, we set up a table of values of 
% amplitude and time from the step response and look for the value of time for 
% which the amplitude is 0.1 and 0.9. We also generate time response data over a 
% defined range of time using t = a:b:c followed by [y,t] = step(G,t). Here, G is 
% an LTI transfer-function object, t is the range for the time axis, where a is the 
% initial time, b is the time step size, and c is the final time; y is the output.

'(ch4p5) UFSS Case Study'           % Display label.
clf                                 % Clear graph.
'(a)'                               % Display label.
numg=0.0169;                        % Define numerator of 2nd order 
                                    % approximation of G(s).
deng=[1 0.226 0.0169];              % Define 2nd order term of 
                                    % denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
omegan=sqrt(deng(3))                % Find natural frequency.
zeta=deng(2)/(2*omegan)             % Find damping ratio.
Ts=4/(zeta*omegan)                  % Find settling time.
Tp=pi/(omegan*sqrt(1-zeta^2))       % Find peak time.
pos=exp(-zeta*pi/sqrt(1-zeta^2))*100	 
                                    % Find percent overshoot.
t=0:0.1:35;                         % Limit time to find rise time. t=0 
                                    % to 35 in steps of 0.1.
[y,t]=step(G,t);                    % Generate and save points of step 
                                    % response over defined range of t. 
T=[y,t];                            % Form a table of values from the 
                                    % step response.
Tlow=table1(T,.1);                  % Search table for time when 
                                    % y=0.1*finalvalue.
Thi=table1(T,.9);                   % Search table for 
                                    % time=0.9*finalvalue.
Tr=Thi-Tlow                         % Calculate rise time.
'(b)'                               % Display label.
numc=0.125*[1 0.435];               % Define numerator of C(s).
denc=conv(poly([0 -1.23]),[1 0.226 0.0169]);
                                    % Define denominator of C(s).
[K,p,k]=residue(numc,denc)          % Find partial fraction expansion.
'(d)'                               % Display label.
numg=0.125*[1 0.435];               % Define numerator of G(s).
deng=conv([1 1.23],[1 0.226 0.0169]);
                                    % Define denominator of G(s).
'G(s)'                              % Display label.	
G=tf(numg,deng)                     % Create and display G(s).
[y,t]=step(G);                      % Generate complete step response
                                    % and collect points.
plot(t,y)                           % Plot points.
title('Pitch Angle Response')       % Add title.
xlabel('Time(seconds)')             % Label time axis.
ylabel('Pitch Angle(radians)')      % Label y axis.
