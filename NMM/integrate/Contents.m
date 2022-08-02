% NMM toolbox:  routines for numerical integration (quadrature)
%
% adaptGK            Adaptive numerical integration using Gauss-Kronrod 7-15 rule
% adaptSimpson       Adaptive numerical integration based on Simpson's rule
% adaptSimpsonTrace  Adaptive numerical integration based on Simpson's rule, returns
%                    additional vector of x values where f(x) was evaluated
% compIntRules    Compare trapezoid, simpson, and Gauss-Legendre quadrature rules
% demoAdaptGK     Exercise adaptive Gauss-Kronrod quadrature and compare with quad8
% demoAdaptSimp   Integrate humps(x) with adaptive Simpson's rule
% demoGauss       Use Gauss-Legendre quadrature to integrate x*exp(-x) on [0,5]
% demoQuad        Use built in quad and quad8 to integrate 'humps' function on [0,5]
% demoSimp        Use composite Simpson's rule to integrate x*exp(-x) on [0,5]
% demoTrap        Use composite trapezoidal rule to integrate x*exp(-x) on [0,5]
% expmx2          Evaluate exp(-x^2), where x is a scalar or vector
% gaussKronrod15  Gauss-Kronrod quadrature pair of order 7 and 15
% gaussLagQuad    Gauss-Laguerre quadrature for integrals on [0,infinity)
% gaussQuad       Composite Gauss-Legendre quadrature
% GLagNodeWt      Nodes and weights for Gauss-Laguerre quadrature of arbitrary order
%                 by solving an eigenvalue problem
% GLagTable       Nodes and weights for Gauss-Laguerre quadrature of order n<=25
% GLNodeWt        Nodes and weights for Gauss-Legendre quadrature of arbitrary order
%                 obtained by solving an eigenvalue problem
% GLTable         Nodes and weights for Gauss-Legendre quadrature of order n<=8
% humpInt         Exact value of integral of humps function on [a,b]
% makeGLagTable   Create a table of Gauss-Laguerre nodes and weights
%                 suitable for copy/paste into the GLagTable.m function
% makeGLTable     Create a table of Gauss-Legendre nodes and weights
%                 suitable for copy/paste into the GLTable.m function
% plotSimpInt     Graphical display of composite Simpson rule integration
% plotTrapInt     Graphical display of composite trapezoid rule integration
% quadToInfinity  Integral from 0 to infinity evaluated as sum of integrals
%                 on subintervals of x axis.  Subintervals size increases
%                 geometrically from x = 0 to infinity.  Sum is terminated when
%                 contribution from subintervals is less than tolerance.
% recursiveIndent Demonstration of a recursive function
% simpson         Composite Simpson's rule
% sinxonx         Evaluate (sin(x)/x)^2  with attention to sin(0)/0 = 1
% trapezoid       Composite trapezoid rule
% trapzDat        Composite trapezoid rule for arbitrarily spaced discrete data
% trapzDatTest    Verify trapzDat function for different types of input
% xemx            Evaluate x exp(-x), where x is a scalar or vector
