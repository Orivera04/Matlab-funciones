function [y]=mmodechi(t0,y0,yp0,t1,y1,yp1,t)
%MMODECHI ODE Cubic Hermite Interpolation. (MM)
% Y=MMODECHI(t0,y0,yp0,t1,y1,yp1,T) interpolates the ODE solution given
% the solution at t0,y0,yp0 and t1,y1,yp1 to estimate the solution at
% the points in T. Usually t0<= T <=t1, but this is not enforced.
%
% The unique cubic polynomial fitting these solution endpoints is found,
% then evaluated at the points in T. The interpolated results are not as
% accurate as true ODE solutions, but can be less expensive to compute and
% are generally more accurate than linear or spline interpolation.
%
% t0,t1 are scalars. y0, yp0, y1, yp1 are equal length vectors.
% Y is a matrix having length(T) rows and length(y0) columns.
%
% P=MMODECHI(t0,y0,yp0,t1,y1,yp1) returns the polynomial matrix P whose
% (i)th polynomial Pi interpolates y(i) in normalized coordinates
% d=(T-t0)./(t1-t0).
%
% MMODEINI must be called first to initialize interpolation matrix.
%
% See also MMODEINI, MMODESS, MMODE45, MMODE45P.

% See: L.F. Shampine, 'Numerical Solution of Ordinary
% Differential Equations,' Chapman and Hall, 1994, pp. 156.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/8/96, modified 9/22/96, 12/16/96, v5: 1/14/97, 2/25/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMODE_CHI

h=(t1-t0);
if h<=0, error('t1 > t0 is Required.'), end

P=MMODE_CHI*[y0(:)';h*yp0(:)';y1(:)';h*yp1(:)'];

if nargin==6, y=P'; return, end

d=(t(:)-t0)./h;
d2=d.*d;
y=[d.*d2 d2 d ones(size(d))]*P; % brute force evaluation for speed
