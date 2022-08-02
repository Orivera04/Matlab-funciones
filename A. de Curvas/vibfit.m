function vibfit   
%
% Example: vibfit
% ~~~~~~~~~~~~~~~
%
% This program illustrates use of the Nelder 
% and Mead multi-dimensional function 
% minimization method to determine an equation 
% for y(t) which depends nonlinearly on several
% parameters chosen to closely fit known data 
% values. The program minimizes the sum of the 
% squares of error deviations between the data 
% values and results produced by the chosen 
% equation. The example pertains to the time 
% response curve characterizing free vibrations 
% of a damped linear harmonic oscillator.
%
% User m functions called: vibfun
%
% Make the data vectors global to allow
% access from function vibfun
global timdat ydat; close

echo off;
disp(' ');
disp('        CHOOSING PARAMETERS');
disp('   IN THE THE NONLINEAR EQUATION');
disp('     Y = A*EXP(B*T)*COS(C*T+D)');
disp('TO OBTAIN THE BEST FIT TO GIVEN DATA');
fprintf('\nPress [Enter] to list function\n');
fprintf('vibfun which is to be minimized\n');
pause;

% Generate a set of data to be fitted by a 
% chosen equation.
a=1.5; b=-.1; c=2.5; d=pi/5;
timdat=0:.2:20; 
ydat=a*exp(b*timdat).*cos(c*timdat+d);

% Add some random noise to the data
ydat=ydat+.1*(-.5+rand(size(ydat)));

% Function vibfun defines the quantity to be 
% minimized by a search using function fmins.
disp(' ');
disp('The function to be minimized is:');
type vibfun.m; disp(' ');
disp('The input data will be plotted next.');
disp('Press [Enter] to continue'); pause;
plot(timdat,ydat,'k.');
title('Input Data'); xlabel('time');
ylabel('y axis'); grid off; figure(gcf);
input('','s'); 

% Initiate the four-dimensional search
x=fminsearch(@vibfun,[1 1 1 1]);

% Check how well the computed parameters 
% fit the data.
aa=x(1); bb=-abs(x(2)); cc=abs(x(3)); dd=x(4);
as=num2str(aa); bs=num2str(bb);
cs=num2str(cc); ds=num2str(dd);
ttrp=0:.05:20; 
ytrp=aa*exp(bb*ttrp).*cos(cc*ttrp+dd);
disp(' ');
disp('Press [Enter] to see how well');
disp('the equation fits the data'); pause;
plot(ttrp,ytrp,'k-',timdat,ydat,'k.');
str1=['Approx. equation is y = ', ...
      'a*exp(b*t)*cos(c*t+d)'];
str2=['a = ',as,'  b = ',bs,'  c = ', ...
      cs,'  d = ',ds];
text(6,-1.1,str1); text(6,-1.25,str2);
xlabel('time'); ylabel('y axis');
title(['Data Approximating ', ...
       'y = 1.5*exp(-.1*t)*cos(2.5*t+pi/4)']);
grid off; figure(gcf);
print -deps apprxdat

%=============================================

function z=vibfun(x)
%
% z=vibfun(x)
% ~~~~~~~~~~~
%
% This function evalautes the least square  
% error for a set of vibration data. The data
% vectors timdat and ydat are passed as global
% variables. The function to be fitted is:
%
%   y=a*exp(b*t)*cos(c*t+d)
%
% x - a vector defining a,b,c and d
%
% z - the square of the norm for the vector 
%     of error deviations between the data and 
%     results the equation gives for current 
%     parameter values
%
% User m functions called:  none
%----------------------------------------------

global timdat ydat
a=x(1); b=-abs(x(2)); c=abs(x(3)); d=x(4);
z=a*exp(b*timdat).*cos(c*timdat+d); 
z=norm(z-ydat)^2;