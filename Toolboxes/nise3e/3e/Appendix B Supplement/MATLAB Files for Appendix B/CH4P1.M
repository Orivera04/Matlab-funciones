% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 4: Time Response
%
% (ch4p1) Example 4.6: We can use MATLAB to calculate characteristics of a 
% second-order system such as damping ratio, z; natural frequency, wn; percent 
% overshoot, %OS (pos); settling time, Ts; and peak time, Tp. Let us look at 
% Example 4.6 in the text. 

'(ch4p1) Example 4.6'               % Display label.		
p1=[1 3+7*i];                       % Define polynomial containing first 
                                    % pole.
p2=[1 3-7*i];                       % Define polynomial containing second 
                                    % pole.
deng=conv(p1,p2);                   % Multiply the two polynomials to
                                    % find the 2nd order polynomial,
                                    % as^2+bs+c.
omegan=sqrt(deng(3)/deng(1))        % Calculate the natural frequency,
                                    % sqrt(c/a).
zeta=(deng(2)/deng(1))/(2*omegan)   % Calculate damping ratio,
                                    % ((b/a)/2*wn).
Ts=4/(zeta*omegan)                  % Calculate settling time, (4/z*wn).
Tp=pi/(omegan*sqrt(1-zeta^2))       % Calculate peak time, pi/wn*sqrt(1- 
                                    % z^2).
pos=100*exp(-zeta*pi/sqrt(1-zeta^2))	   
                                    % Calculate percent overshoot
                                    % (100*e^(z*pi/sqrt(1-z^2)).
