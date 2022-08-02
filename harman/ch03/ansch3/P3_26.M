% P3_26.M  Use a Hilbert matrix (3X3)to show ill conditioning 
%  Answer to A*x=b is x=[1 1 1]
%  Echo is turned on so there is a lot of display
echo on					   % Use echo off to suppress lines	
format rat                               
Aill=[1 1/2 1/3;1/2 1/3 1/4;1/3 1/4 1/5];Aill  % Display Aill with rational fracts.
bill=[11/6 13/12 47/60]';
xill=Aill\bill;                            % MATLAB result    
pause
%
format short				   % This can be misleading	
xill
format long e	      	                   % Look at error more closely
xill
xerror=[1 1 1]'-xill
condno=cond(Aill)
%
%  Experiment a bit with other Hilbert matrices using command hilb.
%  Solve A*x=b with "good" system (condition number about 1) to see
%   that MATLAB error can be much smaller 
%