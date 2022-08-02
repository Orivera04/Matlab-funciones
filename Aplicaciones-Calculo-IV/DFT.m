
% DISCRETE FOURIER TRANSFORM (DFT)PROGRAM 

% Mfile name
%       DFT.m
clc;
clear;

%  Clearing all data, variable names, and files from any other source 
%  and clearing the command window after each successive run of the
%  program

% Revised:
% JULY 01, 2009

% Author
% Dr. Duc Nguyen and Subhash Kadiam

% Keywords
%       General Discrete Fourier Transform (DFT)
%       Fourier Series

% Purpose
% Discrete Fourier Transform Program (DFT).By default, the user defines a set of "k"
% complex function values f(k), where "k" = 1,2,....nn. This DFT
% program will compute the complex function "C(n)" where "n" = 1,2,....nn, such that 
% C(n) = summation of f(k) * exp ^ (-i*k*w0*n)
% where w0 = 2*pi/nn
% This same program can also be used to find the inverse Fourier transform,
% provided that the user has to provide the proper values for "factor and
% isign" (See explanation below).

% Displays title information
disp(sprintf('\n\nDISCRETE FOURIER TRANSFORM (DFT) PROGRAM'))
disp(sprintf('Old Dominion University'))
disp(sprintf('United States of America'))
disp(sprintf('dnguyen@odu.edu\n'))
disp(sprintf('NOTE: This worksheet demonstrates the use of Matlab to illustrate '))
disp(sprintf('Discrete Fourier Transform (DFT) Program'))
disp(sprintf('The user defines a set of "k" complex function values f(k), '))
disp(sprintf('where "k" = 1,2,....nn. This DFT program will compute '))
disp(sprintf(' the complex function "C(n)" where "n" = 1,2,....nn, such that '))
disp(sprintf(' C(n) = summation of f(k) * exp ^ (-i*k*w0*n)'))
disp(sprintf('where w0 = 2*pi/nn '))

% Input data

% if isign = -1 and factor = 1; general_dft = DFT operation is performed.
% if isign = +1 and factor = 1; general_dft = Inverse DFT operation is performed

isign = -1;                                                  % USER DEFINED


% "nn" represents the number of time points, which also mean the number of
% terms used in the Fourier series (in complex numbers).
nn = 8;                                                      % USER DEFINED      
% Factor to be specified by the user
factor = 1;                                                  % USER DEFINED

disp(sprintf('\n\n****************************Input Data*****************************'))
disp(sprintf('     In this simulation, the user needs to provide the following data           ')) 
disp(sprintf('     nn = Specified by the user, the size of the input complex vector           ')) 
disp(sprintf('     isign = Specified by the user  ')) 
disp(sprintf('     Factor = Specified by the user            ')) 

format short g

disp(sprintf('\n-----------------------------------------------------------------\n'))
disp(sprintf('\n   Input data provided by the user   \n'))
disp(sprintf('     nn = %g  \n', nn))
disp(sprintf('     isign = %g  \n', isign))
disp(sprintf('     factor = %g  \n', factor))

disp(sprintf('\n-----------------------------------------------------------------'))

% Input data for DFT in complex format.
% For case 1, the user has to input isign = -1 and factor = 1 and the
% complex vector fk, then general_dft
% code will compute complex vector Cn according to equation 11.59. 

% For case 2, the user has to input isign = +1, factor = 1 
% and the complex vector Cn (obtained from case 1; the user input
% complex vector has to multiply with a factor 1/n before calling general_dft),
% then this general_dft code will
% compute and get back the original complex vector fk according to equation 11.60.

%Case 1 : fcomp = [1-8i 2-7i 3-6i 4-5i 5-4i 6-3i 7-2i 8-1i];
%Case 2 : fcomp = [36.0000-36.0000i -13.6569+5.6569i  -8.0000
%-5.6569-2.3431i -4.0000-4.0000i -2.3431-5.6569i  0-8.0000i
%5.6569-13.6569i];

fcomp = [1-8i 2-7i 3-6i 4-5i 5-4i 6-3i 7-2i 8-1i];
%fcomp = [36.0000-36.0000i -13.6569+5.6569i  -8.0000 -5.6569-2.3431i -4.0000-4.0000i -2.3431-5.6569i  0-8.0000i 5.6569-13.6569i];

% Real component of the complex DFT data is stored
freal = real(fcomp);  

% Imaginary component of the complex DFT data is stored
fimag = imag(fcomp);  

disp('Below is the input data in Complex number format');
%disp(sprintf('     Real part of the complex function  = %g  \n', freal))
%disp(sprintf('     Imaginary part of the complex function  = %g  \n', fimag))
%disp(sprintf('      complex function  = %g %g  \n', freal,fimag))
fcomp

% calculates w0.
w0 = 2*pi/nn;

% Initailizing sumreal to 0.
sumreal = 0;  

% Initailizing sumreal to 0.
sumimag = 0;  
disp('Below is the output data in Complex number format');
for n = 1:nn
    
    % Initailizing cnreal to 0.
    cnreal = 0;  
    
    % Initailizing cnimag to 0.
    cnimag = 0;  
    
    for k = 1:nn
        angle = (k-1)*w0*(n-1);
        
        % calculates cosine of the angle
        c = cos(angle);
        
        % calculates sine of the angle
        s = sin(angle);
        
% Now implementing DFT Eqs. (11.59C, 11.59D)        

    % General DFT
        if (isign == -1.0)   
            cnreal = cnreal+freal(k)*c+fimag(k)*s;
            cnimag = cnimag+fimag(k)*c-freal(k)*s;
            
        else
            
    % General DFT
            if (isign == +1.0)  
            cnreal = cnreal+freal(k)*c-fimag(k)*s;
            cnimag = cnimag+fimag(k)*c+freal(k)*s;
            end
        end

    end

    % Multiplying real component with the factor
    cnreal1 = cnreal*factor;  % General DFT
       
    % Multiplyng imaginary component with the factor
    cnimag1 = cnimag*factor;  % General DFT
    
    cncomp = complex(cnreal1,cnimag1)
    
    % Calculating absolute sum of all the real components
    sumreal = sumreal+abs(cnreal1);
    
    % Calculating absolute sum of all the imaginary components
    sumimag = sumimag+abs(cnimag1);
    %cnreal1d(n) = cnreal1;
    %cnimag1d(n) = cnimag1;
    
end



% Displays DFT Absolute sum of real parts
sumreal; 
disp(sprintf('     Absolute Sum of the real part  = %g  \n', sumreal))


% Displays DFT Absolute sum of imaginary parts
sumimag; 
disp(sprintf('     Absolute Sum of the imaginary part  = %g  \n', sumimag))

%     for i = 1 : nn
%         freal_i = 0;
%         fimag_i = 0;
%         for kk = 0:nn-1
%             
%             k = kk+1;
%             w0 = 2*pi/nn;
%        freal_i = freal_i + cnreal1d(k)*cos(k*w0*i) - cnimag1d(k)*sin(k*w0*i);
%        fimag_i = fimag_i + cnreal1d(k)*sin(k*w0*i) + cnimag1d(k)*cos(k*w0*i);
%        disp(sprintf('   freal_i and freal = %g %g', freal_i, freal(i)));
%        disp(sprintf('   fiamg_i and fimag = %g %g', fimag_i, fimag(i)));
%         end
%     end
       
    
                


