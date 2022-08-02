function ei=eilt(h1,h2,L,n,E)
%
% ei=eilt(h1,h2,L,n,E)
% ~~~~~~~~~~~~~~~~~~~~
%
% This function computes the moment of inertia 
% along a linearly tapered circular cross 
% section and then uses that value to produce
% the product EI.
%
% h1,h2 - column diameters at each end
% L     - column length
% n     - number of points at which ei is
%         computed
% E     - Young's modulus
%
% ei    - vector of EI values along column
%
% User m functions called:  none
%----------------------------------------------

if nargin<5, E=1; end; 
x=linspace(0,L,n)';
ei=E*pi/64*(h1+(h2-h1)/L*x).^4;
ei=[ei(:),x(:)];
