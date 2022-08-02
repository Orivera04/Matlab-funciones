% CLSPEC1.M  Plot positive frequency spectrum of square wave
%  The components are 2/(n pi); n odd. 
%  Plot 10 components of the discrete spectrum [f F]
%   by calling function clptdscf
%
clear
xunit='Hertz';          % Units of frequency
f=[0:1:10];             % Frequency scale
Fn=zeros(1,11);		% Row vector of 11 elements
% Frequency spectrum
for n=1:5		% Compute 5 positive components
 Fn(2*n-1)=2/((2*n-1)*pi); 
end
Fn=[0 Fn];		% Add the zero value
%
clptdscf(f,Fn,xunit)    % Call for plot
%
% Notice that the frequency increment is 1 from 0 to 10.
% Modify the file to allow input the period of the pulse train
%  and plot the spectrum in appropriately scaled units
