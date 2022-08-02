%---------------------------------------------------------------------------
%ALGOS
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address: mathews@fullerton.edu
%
% This free software is complements of the author.
%
% These functions are User Contributed Routines which are being distributed by
% The MathWorks, upon request, on an "as is" basis.  A User Contributed Routine
% is not a product of The MathWorks and The MathWorks assumes no responsibility
% for any errors that may exist in these routines.
%
% 
% 
% CONTENTS
% 
% Chapter 1. Preliminaries
% 
%   Theorem 1.1   Limits and Continuous Functions
%   Theorem 1.2   Intermediate Value Theorem
%   Theorem 1.3   Extreme Value Theorem for a Continuous Function
%   Theorem 1.4   Differentiable function implies continuous function
%   Theorem 1.5   Rolle's Theorem
%   Theorem 1.6   Mean Value Theorem
%   Theorem 1.7   Extreme Value Theorem for a Differentiable Function
%   Theorem 1.8   Generalized Rolle's Theorem
%   Theorem 1.9   First Fundamental Theorem
%   Theorem 1.10  Second Fundamental Theorem
%   Theorem 1.11  Mean Value Theorem for Integrals
%   Theorem 1.12  Weighted Integral Mean Value Theorem
%   Theorem 1.13  Taylor's Theorem
%   Theorem 1.14  Horner's Method for Polynomial Evaluation
%   Theorem 1.15  Geometric Series
%   Theorem 1.16  Big "O" remainders for Taylor's Theorem
%   Theorem 1.17  Remainder term for Taylor's Theorem
% 
% Chapter 2. The Solution of Nonlinear Equations f(x) = 0
% 
%   Algorithm 2.1   Fixed Point Iteration
%   Algorithm 2.2   Bisection Method
%   Algorithm 2.3   False position or Regula Falsi Method
%   Algorithm 2.4   Approximate Location of Roots
%   Algorithm 2.5   Newton-Raphson Iteration
%   Algorithm 2.6   Secant Method
%   Algorithm 2.7   Steffensen's Acceleration
%   Algorithm 2.8   Muller's Method
%   Algorithm 2.9   Nonlinear Seidel Iteration
%   Algorithm 2.10  Newton-Raphson Method in 2-Dimensions
% 
% Chapter 3.  The Solution of Linear Systems  AX = B
% 
%   Algorithm 3.1   Back Substitution
%   Algorithm 3.2   Upper-Triangularization Followed by Back Substitution
%   Algorithm 3.3   PA = LU Factorization with Pivoting
%   Algorithm 3.4   Jacobi Iteration
%   Algorithm 3.5   Gauss-Seidel Iteration
% 
% Chapter 4.  Interpolation and Polynomial Approximation
% 
%   Algorithm 4.1   Evaluation of a Taylor Series
%   Algorithm 4.2   Polynomial Calculus
%   Algorithm 4.3   Lagrange Approximation
%   Algorithm 4.4   Nested Multiplication with Multiple Centers
%   Algorithm 4.5   Newton Interpolation Polynomial
%   Algorithm 4.6   Chebyshev Approximation
% 
% Chapter 5.  Curve Fitting
% 
%   Algorithm 5.1   Least Squares Line
%   Algorithm 5.2   Least Squares Polynomial
%   Algorithm 5.3   Non-linear Curve Fitting
%   Algorithm 5.4   Cubic Splines
%   Algorithm 5.5   Trigonometric Polynomials
% 
% Chapter 6.  Numerical Differentiation
% 
%   Algorithm 6.1   Differentiation Using Limits
%   Algorithm 6.2   Differentiation Using Extrapolation
%   Algorithm 6.3   Differentiation Based on N+1 Nodes
% 
% Chapter 7.  Numerical Integration
% 
%   Algorithm 7.1   Composite Trapezoidal Rule
%   Algorithm 7.2   Composite Simpson Rule
%   Algorithm 7.3   Recursive Trapezoidal Rule
%   Algorithm 7.4   Romberg Integration
%   Algorithm 7.5   Adaptive Quadrature Using Simpson's Rule
%   Algorithm 7.6   Gauss-Legendre Quadrature
% 
% Chapter 8.  Numerical Optimization
% 
%   Algorithm 8.1   Golden Search for a Minimum
%   Algorithm 8.2   Nelder-Mead's Minimization Method
%   Algorithm 8.3   Local Minimum Search Using Quadratic Interpolation
%   Algorithm 8.4   Steepest Descent or Gradient Method
% 
% Chapter 9.  Solution of Differential Equations
% 
%   Algorithm 9.1   Euler's Method
%   Algorithm 9.2   Heun's Method
%   Algorithm 9.3   Taylor's Method of Order 4
%   Algorithm 9.4   Runge-Kutta Method of Order 4
%   Algorithm 9.5   Runge-Kutta-Fehlberg Method RKF45
%   Algorithm 9.6   Adams-Bashforth-Moulton Method
%   Algorithm 9.7   Milne-Simpson Method
%   Algorithm 9.8   The Hamming Method
%   Algorithm 9.9   Linear Shooting Method
%   Algorithm 9.10  Finite-Difference Method
% 
% Chapter 10.  Solution of Partial Differential Equations
% 
%   Algorithm 10.1  Finite-Difference Solution for the Wave Equation
%   Algorithm 10.2  Forward-Difference Method for the Heat Equation
%   Algorithm 10.3  Crank-Nicholson Method for the Heat Equation
%   Algorithm 10.4  Dirichlet Method for Laplace's Equation
% 
% Chapter 11.  Eigenvalues and Eigenvectors
% 
%   Algorithm 11.1  Power Method
%   Algorithm 11.2  Shifted Inverse Power Method
%   Algorithm 11.3  Jacobi Iteration for Eigenvalues and Eigenvectors
%   Algorithm 11.4  Reduction to Tridiagonal Form
%   Algorithm 11.5  The QL Method with Shifts
% 
% 
% 
