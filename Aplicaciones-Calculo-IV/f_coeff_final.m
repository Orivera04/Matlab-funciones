% FOURIER COEFFICIENTS PROGRAM 

% Mfile name
%       f_coeff_final.m

function f_coeff_final()
clc
clear
close all
clear all

%  Clearing all data, variable names, and files from any other source 
%  and clearing the command window after each successive run of the
%  program

% Revised:
% JULY 01, 2009

% Author
% Dr. Duc Nguyen and Subhash Kadiam

% Keywords
%       Fourier Coefficients
%       Fourier Series
       


% Purpose
% Fourier Coefficient Program

% Displays title information

disp(sprintf('\n\nFOURIER COEFFICIENTS PROGRAM'))
disp(sprintf('Old Dominion University'))
disp(sprintf('United States of America'))
disp(sprintf('dnguyen@odu.edu\n'))
disp('NOTE: This worksheet demonstrates the use of Matlab to illustrate ')
disp('Fourier Coefficients Program')

% Calls function inputdata - user provides input data
inputdata;

% Calls function coeff - calculates coefficients a0, a1.....an, b1.....bn
coeff;

end

%%
% User provide input data here.

function [] = inputdata();
global n t1 ft1 ft11 t2 ft2 ft22 t3 ft3 ft33 t4 f4 t5 f5 nterms_ak

% Within each segment, we use 1000 points in order to produce a smooth plot.
n = 1000;

% nterms_ak : represents number of fourier coefficients ak and bk.
nterms_ak = 8;

% In this program, the given periodic function f(t) will be approximated by
% Fourier (sine and cosine) series. The program will compute the fourier
% coefficients a0, a1......a8 (assuming n_terms = 8, since it is unneccessary 
% to use more fourier terms ), b1........b8.
% The original function and the approximated fourier function are plotted
% for comparison purpose. Also all the fourier coefficients are also
% printed.

% The function provided by the user can have from "1" upto "4" segments.
% The user only has to define the following parameters.

% nsegment = ?
% Lower and upper time integration limit for each segment = ?
% Define the corresponding function = ?

% The following worksheet provides four examples for which the given
% function can be defined by 1,2,3 and 4 segments, respectively.


% with each segment represented in the given fashion:
% t(i)_start : Lower limit of time, for segment "i"
% t(i)_end : Upper limit of time, for segment "i" 
% ft(i) : User defined function in segment "i".
% where i = 1,2....nsegment.

nsegment = 1;                                                % USER DEFINED

% NOTE : Depending on the user's input value for nsegment, he/she "ONLY" has
% to modify the data shown in segment 1, or segment 2, or segment 3, or
% segment 4.

%Segment 1
if (nsegment == 1)
t1_start = 0;                                                % USER DEFINED
t1_end = 2*pi;                                               % USER DEFINED
t1 = [t1_start:(1/n):t1_end];
ft1 = -t1;                                                   % USER DEFINED
ft11 = (ft1 + zeros(size(t1)));

t5 = [t1];
f5 = [ft11];

end

%Segment 2
if (nsegment == 2)
t1_start = 0;                                                % USER DEFINED
t1_end = pi;                                                 % USER DEFINED

t2_start = pi;                                               % USER DEFINED
t2_end = 2*pi;                                               % USER DEFINED

t1 = [t1_start:(1/n):t1_end];
ft1 =  t1;                                                   % USER DEFINED
ft11 = (ft1 + zeros(size(t1)));

t2 = [t2_start:(1/n):t2_end];
ft2 = pi;                                                    % USER DEFINED
ft22 = (ft2 + zeros(size(t2)));

t5 = [t1 t2];
f5 = [ft11 ft22];
end

%Segment 3
if (nsegment == 3)
t1_start = -pi;                                              % USER DEFINED
t1_end = -pi/2;                                              % USER DEFINED

t2_start = -pi/2;                                            % USER DEFINED
t2_end = pi/2;                                               % USER DEFINED

t3_start = pi/2;                                             % USER DEFINED
t3_end = pi;                                                 % USER DEFINED


t1 = [t1_start:(1/n):t1_end];
ft1 = -pi/2;                                                 % USER DEFINED
ft11 = (ft1 + zeros(size(t1)));

t2 = [t2_start:(1/n):t2_end];
ft2 = -t2;                                                   % USER DEFINED
ft22 = (ft2 + zeros(size(t2)));

t3 = [t3_start:(pi/n):t3_end];
ft3 = -pi/2;                                                 % USER DEFINED
ft33 = (ft3 + zeros(size(t3)));

t5 = [t1 t2 t3];
f5 = [ft11 ft22 ft33];

end
 
%Segment 4
if (nsegment == 4)
t1_start = -2;                                               % USER DEFINED
t1_end = -1;                                                 % USER DEFINED

t2_start = -1;                                               % USER DEFINED
t2_end = 0;                                                  % USER DEFINED

t3_start = 0;                                                % USER DEFINED
t3_end = 1;                                                  % USER DEFINED

t4_start = 1;                                                % USER DEFINED
t4_end = 2;                                                  % USER DEFINED


t1 = [t1_start:(1/n):t1_end];
ft1 = 1;                                                     % USER DEFINED
ft11 = (ft1 + zeros(size(t1)));

t2 = [t2_start:(1/n):t2_end];
ft2 = -1;                                                    % USER DEFINED
ft22 = (ft2 + zeros(size(t2)));

t3 = [t3_start:(pi/n):t3_end];
ft3 = 1;                                                     % USER DEFINED
ft33 = (ft3 + zeros(size(t3)));

t4 = [t4_start:(pi/n):t4_end];
ft4 = -1;                                                    % USER DEFINED
ft44 = (ft4 + zeros(size(t4)));


t5 = [t1 t2 t3 t4];
f5 = [ft11 ft22 ft33 ft44];

end

%t5 gathers all the time interval in to single vector
%f5 holds the function corresponding to the time interval "t"

disp(sprintf('\n\n********************************************Input Data**********************************************'))
disp(sprintf('         In this simulation, we assume the given periodic function is splitted into 1- 4 segments           ')) 
disp(sprintf('                        t(i)_start : Lower limit of time, for segment "i"                                   '))
disp(sprintf('                        t(i)_end : Upper limit of time, for segment "i"                                     '))
disp(sprintf('                        ft(i) : User defined function in segment "i".                                       '))
disp(sprintf('                                where i = 1,2....nsegment.                                                   ')) 


format short g

disp(sprintf('\n-----------------------------------------------------------------\n'))
disp(sprintf('\n   In this simulation, we internally set the value of parameter nterms_ak = 8   \n'))
disp(sprintf('\n-----------------------------------------------------------------'))
end

%%
% calculates coefficients a0, a1.....an, b1.....bn
function [] = coeff()
global t5 f5 nterms_ak

% t5_first stores the first value of the total integration
t5_first = t5(1);

% t5_last stores the last value of the total integration 
t5_last = t5(length(t5));

p_value = ((t5_last - t5_first)/2);

% Calculates period
period = 2 * pi;

% Calculates Angular Frequency
angfreq = 2 * pi / period;

% calculation of a0
disp(sprintf('     Fourier Coefficient for "a0" is:           '))
a0 =  trapz(t5,f5) / (2*pi)

% %Initializing angular frequency
% angfreq = zeros(nterms_ak,1);
% 
% for i = 1:nterms_ak
%     angfreq(i) = i;
% end

% calculation of ak and bk

% Initializing "a" and "b" vectors 
a = zeros(nterms_ak,1);
b = zeros(nterms_ak,1);

for i = 1:nterms_ak
    
        theta = i*pi.*t5./p_value;
        c_value = cos(theta);
        s_value = sin(theta);
        a_value = c_value.*f5;
        b_value = s_value.*f5;
        a(i) = (trapz(t5,a_value))/p_value;
        b(i) = (trapz(t5,b_value))/p_value;
end

disp(sprintf('     Fourier Coefficients for a1,a2...........a8 are as follows:           ')) 
    a
disp(sprintf('     Fourier Coefficients for b1,b2...........b8 are as follows:           '))
    b

    f_ft = (a0)*ones(size(t5));
    
    
    % calculates final fourier series
    
    for i = 1:nterms_ak
        f_ft = f_ft + (a(i).*cos(i*pi.*t5./p_value)) +  (b(i).*sin(i*pi.*t5./p_value));
    end
    
    figure;
    plot(t5,f5,'LineWidth',2);
    hold on;
    plot(t5,f_ft,'-.','LineWidth',2);
    grid on
    title('Plots of Original function and Fourier Series for n_terms = 8');
    xlabel('t');
    ylabel('f(t)');
    legend('Original function f(t)', 'Approximated Fourier function');
    
disp('The figure shows the plots of both Original function and the approximated function from the Fourier series ') 
disp('The continuous blue line "-" represents the Original function and the discontinuous blue line "-. " ')
disp('represents the approximated Fourier series. ')
end



