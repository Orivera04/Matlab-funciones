function x = Stirling(n,o);
%STIRLING   Stirling's approximation to factorials.
%   X=STIRLING(n,o) with an o=1 returns the logarithm of the factorial value 
%and with an o=2 returns the factorial value for n as large as 170 (a greater
%value returns INF for it exceeds the largest floating point number, e+308).
%(For a better expansion it is used the Kemp (1989) and Tweddle (1984)
%suggestions.)
%     
%     Inputs:
%          n - can be a fractional or a scalar.
%          o - option of the result (logarithm of the factorial value = 1;
%              factorial value = 2)[default = 2].
%          

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  June 09, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). Stirling: Stirling's approximation
%    to factorials. A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%    fileexchange/loadFile.do?objectId=3600&objectType=FILE
%  
%  References:
% 
%  Kemp, A. W. (1989), A note on Stirling's expansion for
%           factorial n. Statist. Prob. Lett. 7: 21-22.
%  Tweddle, I. (1984), Approximating n! Historical origins
%           and error analysis. Amer. J. Phys. 52: 487-488.
%

if nargin < 2,
   o = 2;  %(default)
end;

y = (n + 0.5)*log10(n + 0.5) - 0.434294*(n + 0.5) + 0.399090;

if o == 1;
   x = y;
else o == 2;
   x = 10^y;
end;

   

