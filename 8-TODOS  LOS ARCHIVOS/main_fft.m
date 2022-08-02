clc;
clear;

% Main
% Mfile name
%       main_fft.m

%IMPORTANT NOTE:
% In order to use main_fft.m the user need to download general_fft.m,
% bitreverse.m, unscramble.m in to his working directory.

% Revised:
%       July 1, 2009

% % Authors
%       Duc Nguyen and Siroj Tungkahotara
%       Department of Civil and Environmental Engineering
%       Old Dominion University
%       Contact: dnguyen@odu.edu

% Purpose
%       To find fast fourier transform or fft

% Keyword
%       fft
%       unscramble
%       bitreverse
%       

% Inputs
%       This is the only place in the program where the user makes the changes

% iautodata = 0; if user provide input data for fft
% iautodata = 1; if user do not provide input data for fft
iautodata = 0;

% n = number of complex data points = 2^igama
n = 8;

% igama = integer power to compute N = 2^igama
igama = 3;

% if isign = -1 and factor = 1; general_fft = FFT operation is performed.
% if isign = +1 and factor = 1; general_fft = IFFT operation is performed. 
sign = -1;

% factor   - either 1, or 1/n, or general factor
%                   (for Civil Engineering application)
factor = 1;


% checking if the input data for fft is provided by the user
if (iautodata == 1)
    freal(1:n) = (1:n);
    fimag(1:n) = 0.0;
elseif (iautodata == 0)

%       This is the only place in the program where the user makes the
%       changes
%       user to be provided in complex number

% For case 1, the user has to input isign = -1 and factor = 1 and the
% complex vector fk, then general_fft
% code will compute complex vector Cn according to equation 11.59. This
% result is also matched with MATLAB built-in function fft (where the user
% only have to provide input complex vector fk).

% For case 2, the user has to input isign = +1, factor = 1 
% and the complex vector Cn (obtained from case 1; the user input
% complex vector has to multiply with a factor 1/n before calling general_fft),
% then this general_fft code will
% compute and get back the original complex vector fk according to equation 11.60.
% Our results will also match with MATLAB built-in function "ifft" (Inverse
% Fast Fourier Transform) if the user only has to provide the complex vector Cn
% (obtained from case 1). 


%Case 1 : fcomp = [1-8i 2-7i 3-6i 4-5i 5-4i 6-3i 7-2i 8-1i];
%Case 2 : fcomp = [36.0000-36.0000i -13.6569+5.6569i  -8.0000
%-5.6569-2.3431i -4.0000-4.0000i -2.3431-5.6569i  0-8.0000i
%5.6569-13.6569i];

fcomp = [1-8i 2-7i 3-6i 4-5i 5-4i 6-3i 7-2i 8-1i];
% finds the real part and stores in freal
freal = real(fcomp);

% finds the imaginary part and stores in fimag
fimag = imag(fcomp);

end

disp(sprintf('---------------------------------------------------------'));
disp(sprintf('---------------------------------------------------------'));
disp(sprintf('          Prof. Duc T Nguyen and Siroj Tungkahotara      '));
disp(sprintf('           General Fast Fourier Transform Program        '));
disp(sprintf('             Department of Civil Engineering             '));
disp(sprintf('                 Old Dominion University                 '));
disp(sprintf('---------------------------------------------------------'));
disp(sprintf('---------------------------------------------------------'));

disp(sprintf('                      Introduction                       '));
disp(sprintf('\n        This program demonstrates the use of MATLAB to '));
disp(sprintf('            illustrate general fast fourier transform    '));

disp(sprintf('\n------------------Section 1: Input --------------------'));
format short g

disp(sprintf('\n iautodata::iautodata = 0; if user provide input data for fft'));
disp(sprintf('\n iautodata = 1; if user do not provide input data for fft = %g',iautodata));
disp(sprintf('\n n:: number of complex data points = 2^igama = %g',n));
disp(sprintf('\n igama:: Integer power to compute N = 2^igama = %g',igama));
disp(sprintf('\n if isign = -1 and factor = 1; general_fft = FFT operation is performed.'));
disp(sprintf('\n if isign = +1 and factor = 1; general_fft = IFFT operation is performed.')); 
disp(sprintf('\n the user input complex vector has to multiply with a factor 1/n before calling general_fft'));
disp(sprintf('\n then this general_fft code will compute and get back the original complex vector'));
disp(sprintf('\n fk according to equation 11.60. Our results will also match with MATLAB built-in function "ifft"'));

disp(sprintf('\n sign :: provided by the user =%g', sign));
disp(sprintf('\n factor ::either 1, or 1/n, or general factor'));
disp(sprintf('\n (for Civil Engineering application)'));
disp(sprintf('\n factor :: provided by the user =%g', factor));

% Displays input
%fprintf('INPUT DATA, freal, fimag \n')
disp(sprintf('\n freal :: Input data provided by the user (real part) =%g', freal));
disp(sprintf('\n fimag :: Input data provided by the user (imaginary part) =%g', fimag));
%[freal',fimag']


% Function general_fft is called to calculate fft.
[freal, fimag] = general_fft(freal,fimag,n,igama,sign,factor);

% displays output
%fprintf('OUTPUT DATA, freal, fimag \n')
disp(sprintf('\n freal :: Output real part  =%g', freal));
disp(sprintf('\n fimag :: Output Imaginary  =%g', fimag));

