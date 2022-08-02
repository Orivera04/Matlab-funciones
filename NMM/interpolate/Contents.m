% NMM toolbox:  routines for interpolation
%
% binSearch         Binary search to find index i such that x(i)<= xhat <= x(i+1)
% binSearch.c       C source code for binSearch.mex
% compInterp        Compare flops for interpolation with different polynomial bases
% compNotKnot       Compare implementations of splines with not-a-knot end conditions
%                   NMM toolbox routine splint, is compared with built in spline
%                   function in the interpolation of y=x*exp(-x) on [0,5]
% compSplintFlops   Show flops savings due to sparse storage in spline interp
% compSplinePlot    Compare cubic splines w/ different end conditions
%                   Approximations to y = x*exp(-x) are constructed and plotted
% demoGasLag        Interpolate gasoline price data with Lagrange polynomials
% demoGasNewt       Interpolate gasoline price data with Newton polynomials
% demoGasVand       Interpolate gas price data using monomial basis functions
% demoGasVandShift  Interpolate gas price data using monomials and shifted dates
% demoHermite       Piecewise cubic Hermite interpolation of y = x*exp(-x) on [0,5]
% demoInterp1       Use built in interp1 function on data sampled from 'humps'
% demoLinterp       Script demonstrating linterp function with thermocouple data
% demoSplineFE      Spline approx to y = x*exp(-x) with fixed slope end conditions
% demoWiggle        Plot wiggle from increasing order of polynomial interpolant
% divdiffTable      Construct a table of divided difference coefficients
% hermint           Piecewise cubic Hermite interpolation
% lagrint           Interpolation with Lagrange polynomials of arbitrary degree
% linterp           Piecewise linear interpolation in a table of (x,y) data
% newtint           Interpolation with a Newton polynomias of arbitrary degree
% splint            Cubic spline interpolation with various end conditions
% splintFE          Cubic spline interpolation with fixed slop end conditions
% splintFull        Cubic-spline interpolation with various end conditions; full matrix storage
