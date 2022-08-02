%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
% 
%  File and function name : test_rotation
%  Version                : 1.0
%  Date of completion     : 5 September 2003
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%
%  Inputs        :
%
%  Outputs       :   
%
%  Description   :
%       Test the function "rotation.m"
%
%  To Run >>    test_rotation
function test_rotation

clc
coord = [1 1; -1 -1];
center = [0 0];
max_coord = max(coord(:)) + 0.5;
maxpts = [max_coord max_coord;-1*max_coord -1*max_coord];
pause_time = 0.1;
H = figure;

degree_angle_range  = [0:-10:-180];
degree_angle_range2 = [0:10:180];
radian_angle_range  = [0:-pi/18:-pi];
radian_angle_range2 = [0:pi/18:pi];
% =================================================
% Plot in degrees
% =================================================
disp('***********************');
disp('Rotation by degrees');
disp('***********************');
disp('-----------------------');
disp('Clockwise');
disp('-----------------------');
for ang = degree_angle_range,
    c = rotation(coord,center,ang);
    hold off;
    plot(coord(:,1),coord(:,2),'b*-');
    hold on;
    plot(c(:,1),c(:,2),'r+-');
    plot(maxpts(:,1),maxpts(:,2),'.');
    plot(center(1),center(2),'xk');
    title('Clockwise by degrees');
    pause(pause_time);
end;

% disp('Press Any Key To Continue .....');
pause(1);

disp('-----------------------');
disp('Anti-clockwise');
disp('-----------------------');
for ang = degree_angle_range2
    c = rotation(coord,center,ang);
    hold off;
    plot(coord(:,1),coord(:,2),'b*-');
    hold on;
    plot(c(:,1),c(:,2),'r+-');
    plot(maxpts(:,1),maxpts(:,2),'.');
    plot(center(1),center(2),'xk');
    title('Anti-Clockwise by degrees');
    pause(pause_time);
end;

% disp('Press Any Key To Continue .....');
pause(1);

% =================================================
% Plot in radians
% =================================================
disp('***********************');
disp('Rotation by radians');
disp('***********************');
disp('-----------------------');
disp('Clockwise');
disp('-----------------------');
for ang = radian_angle_range
    c = rotation(coord,center,ang,'radians');
    hold off;
    plot(coord(:,1),coord(:,2),'b*-');
    hold on;
    plot(c(:,1),c(:,2),'r+-');
    plot(maxpts(:,1),maxpts(:,2),'.');
    plot(center(1),center(2),'xk');
    title('Clockwise by radians');
    pause(pause_time);
end;

% disp('Press Any Key To Continue .....');
pause(1);

disp('-----------------------');
disp('Anti-clockwise');
disp('-----------------------');
for ang = radian_angle_range2
    c = rotation(coord,center,ang,'radians');
    hold off;
    plot(coord(:,1),coord(:,2),'b*-');
    hold on;
    plot(c(:,1),c(:,2),'r+-');
    plot(maxpts(:,1),maxpts(:,2),'.');
    plot(center(1),center(2),'xk');
    title('Anti-Clockwise by radians');
    pause(pause_time);
end;

% disp('Press Any Key To Exit .....');
pause(2);
close(H);
clc;