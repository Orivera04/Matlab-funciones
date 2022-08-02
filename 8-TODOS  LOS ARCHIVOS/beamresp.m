function [t,x,displ,mom]= ...
      beamresp(ei,arho,len,m0,w0,tmin,tmax, ...
               nt,xmin,xmax,nx,ntrms)
%
% [t,x,displ,mom]=beamresp(ei,arho,len,m0, ...
%           w0,tmin,tmax,nt,xmin,xmax,nx,ntrms)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates the time dependent 
% displacement and moment in a constant 
% cross-section simply-supported beam which 
% is initially at rest when a harmonically 
% varying moment is suddenly applied at the 
% right end.  The resulting time histories of 
% displacement and moment are computed.
%
% ei        - modulus of elasticity times 
%             moment of inertia
% arho      - mass per unit length of the 
%             beam
% len       - beam length
% m0,w0     - amplitude and frequency of the 
%             harmonically varying right end 
%             moment
% tmin,tmax - minimum and maximum times for
%             the solution
% nt        - number of evenly spaced 
%             solution times
% xmin,xmax - minimum and maximum position 
%             coordinates for the solution. 
%             These values should lie between 
%             zero and len (x=0 and x=len at 
%             the left and right ends).
% nx        - number of evenly spaced solution 
%             positions
% ntrms     - number of terms used in the 
%             Fourier sine series
% t         - vector of nt equally spaced time 
%             values varying from tmin to tmax
% x         - vector of nx equally spaced 
%             position values varying from 
%             xmin to xmax
% displ     - matrix of transverse 
%             displacements with time varying 
%             from row to row, and position 
%             varying from column to column
% mom       - matrix of bending moments with 
%             time varying from row to row, 
%             and position varying from column 
%             to column
%
% User m functions called:  ndbemrsp
%----------------------------------------------

tcof=sqrt(arho/ei)*len^2; dcof=m0*len^2/ei;
tmin=tmin/tcof; tmax=tmax/tcof; w=w0*tcof;
xmin=xmin/len; xmax=xmax/len;
[t,x,displ,mom]=...
ndbemrsp(w,tmin,tmax,nt,xmin,xmax,nx,ntrms);
t=t*tcof; x=x*len; 
displ=displ*dcof; mom=mom*m0;