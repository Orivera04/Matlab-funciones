% NMM toolbox:  routines for solution of Ordinary Differential Equations
%
% compEM         Compare Euler and Midpoint for solution of dy/dx = -y;  y(0) = 1
% compEMRK4      Compare flops and accuracy of Euler, Midpoint and RK4 methods
%                for the solution of  dy/dt = -y;  y(0) = 1
% demoEuler      Integrate dy/dt = t - 2*y;  y(0) = 1 with Euler's method
% demoODE45      Integrate dy/dx = -y;  y(0) = 1 with ode45
% demoODE45args  Integrate dy/dt = -alpha*y;  y(0) = 1 with ode45 and variable alpha
% demoODE45opts  Integrate dy/dx = -y;  y(0) = 1 with ode45 and user-selected options
% demoPredprey   Coupled ODEs for a two-species predator-prey simulation
% demoRK4        Integrate  dy/dx = -y;  y(0) = 1 with RK4 method
% demoSmd        Second order system of ODEs for a spring-mass-damper system
% demoSteel      Solve ODE describing heat treating of a steel bar using ode45
% demoSystem     Solve system of two coupled first order ODEs
% odeEuler       Euler's method for integration of a single, first order ODE
% odeMidpt       Midpoint method for integration of a single, first order ODE
% odeRK4         Fourth order Runge-Kutta method for a single, first order ODE
% odeRK4sys      Fourth order Runge-Kutta method for systems of first order ODEs
%                Non vectorized version
% odeRK4sysv     Fourth order Runge-Kutta method for systems of first order ODEs
%                Vectorized version with pass-through parameters.
% odeRK4v        Fourth order Runge-Kutta method for a single, first order ODE
%                Vectorized version with pass-through parameters.
% rhs1           Evaluate right hand side of dy/dt = t - 2*y 
% rhs2           Evaluate right hand side of dy/dt = -y 
% rhsDecay       Evaluate right hand side of dy/dt = -alpha*y with a variable alpha
% rhsPop2        Right hand sides of coupled ODEs for 2 species predator-prey system
% rhsSmd         Right hand sides of coupled ODEs for a spring-mass-damper system
% rhsSteelHeat   Right hand side of first order ODE for heat treating simulation
% rhsSys         Right hand side vector for two, coupled, first order ODEs
% testSteel      Verify that solutions obtained by ode45 are independent of
%                interpolative refinement.  Solution is obtained with default
%                refinement (= 4) and with no refinement.
