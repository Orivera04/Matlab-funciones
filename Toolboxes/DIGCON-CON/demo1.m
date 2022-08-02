%DEMO1	Demonstration script: design and simulation of a digital regulator.
%
%	DEMO1 uses the State Space Digital Control Toolbox to design,
%	analyze, and simulate digital regulators for the inverted pendulum
%	on a cart.  Both full-state feedback and observers are shown.

% R.J. Vaccaro 1/95


load sroots
fprintf('-- DEMO1 -- Inverted Pendulum Regulation\n\n');
fprintf('This is a demonstration of the design and simulation of\n')
fprintf('a regulator for the inverted pendulum system described in the\n')
fprintf('textbook "Digital Control: A State-Space Approach,"\n')
fprintf('by R.J. Vaccaro, McGraw-Hill, 1995\n\n')
fprintf('A state-space model for the system is\n\n');
fprintf('           dx/dt = A*x + b*u\n')
fprintf('\nwhere x contains the state variables and u is the input.\n');
fprintf('The column vector x consists of 4 state variables:\n ');
fprintf('\n[pendulum position, pendulum velocity, motor position, motor velocity]\n\n');
fprintf('(See Section 3.6.6, page 121, and Example 6.9, page 238)\n')
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('The numerical values for the state-space model are:\n')
A=[0 1 0 0;23.1 0 0 -.11892627;0 0 0 1; 0 0 0 -25]
b=[0;12.5253;0;2633]
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('A vector of analog feedback gains that places the closed-loop poles\n')
fprintf('at the roots of the 4-th order normalized Bessel polynomial scaled \n')
fprintf('to achieve a settling time of 0.95 seconds can be calculated using \n')
fprintf('the FBG function as follows ')
fprintf('(See Table 6.3, page 233 in the text book)\n')
s4
fprintf('>>La=fbg(A,b,s4/0.95)\n')
La=fbg(A,b,s4/0.95)
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('\n\nThe bandwidth of this analog regulator can be determined to be w_B = 20 rad/sec\n')
fprintf('using the ABODEP function (see Section 6.4.5, page 237 in the book)\n\n')
fprintf('>>abodep(A-b*La,b,La,0) \n\n')
abodep(A-b*La,b,La,0)
fprintf('\n*      *       *       *       *       *       *       *       *\n\n')
fprintf('Using equation (6.43),  this gives the following range for\n')
fprintf('the sampling interval:\n\n')
fprintf('(pi/(20*w_B)) < T < (pi/(10*w_B))  or   0.008 < T < 0.016.\n')
fprintf('\nWe choose the sampling interval to be T=0.01 seconds\n')
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('The zero-order-hold equivalent model is calculated using the ZOHE function\n\n')
T=0.01;
fprintf('>>[phi,gamma]=zohe(A,b,T)\n')
[phi,gamma]=zohe(A,b,T)
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('The feedback gains for the digital regulator are calculated using FBG\n\n')
fprintf('>>L=fbg(phi,gamma,exp(T*s4/0.95))\n')
L=fbg(phi,gamma,exp(T*s4/0.95))
fprintf('\n\nThe stability margins for this regulator can be calculated\n')
fprintf('using the SM function as follows\n\n')
fprintf('>>sm(phi,gamma,L)\n\n')
sm(phi,gamma,L)
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('We could also determine the stability margins from a Nyquist\n')
fprintf('plot using the NYQ function: nyq(phi,gamma,L,0).  Once the plot is\n')
fprintf('displayed, the NYQ command provides the user with several useful options:\n\n')
;
fprintf('       zoom - use cursor  and click on lower left and upper right\n');
fprintf('              points to zoom in on a portion of the plot.\n');
fprintf('      point - use cursor to click on any part of the plot.  Magnitude,\n');
fprintf('              phase, and frequency of the closest calculated point are shown.\n')
fprintf('   original - returns to the original plot.\n');
fprintf('      cross - shows only points that were actually evaluated.\n');
fprintf('       axes - allows numerical setting of x and y axes.\n');
fprintf('unit circle - draws the unit circle on the current plot.\n');

fprintf('\n<Press return to generate this plot.>\n');
pause;
fprintf('\n>>nyq(phi,gamma,L,0)\n')
nyq(phi,gamma,L,0) 

fprintf('\n*      *       *       *       *       *       *       *       *\n\n')
fprintf('The behavior of the digital state-feedback regulator can be\n')
fprintf('simulated using the REGSF script.  In order to use this script\n')
fprintf('the following 6 variables must be defined in the workspace:\n')
fprintf('\nphi, gamma - the ZOH plant model\n');
fprintf('   T       - the sampling period\n');
fprintf('   L       - the feedback gains\n');
fprintf('   x0      - the initial value of the state vector\n');
fprintf('   ftime   - the final time in the simulation\n');

x0=[.17 0 0 0]';
ftime=2;

fprintf('\n                   <Press return to continue.>\n\n');
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('For this demonstration the pendulum will be started at an angle \n');
fprintf('of 0.17 radians (10 degrees) with zero velocity.  The cart will be\n');
fprintf('centered on its track.  The simulation will run for 2 seconds \n');
fprintf('Once the variables listed above have been defined, the user need only\n')
fprintf('type "regsf" to run the simulation script.\n\n');
fprintf('The script adds three variables to the workspace: x contains the \n');
fprintf('time history of the state vector, u is the history of inputs, and\n');
fprintf('t1 contains the time at each sample.\n\n');
fprintf('\n              <Press return to execute regsf.>\n\n');
pause
fprintf('>>regsf\n\n')
regsf

fprintf('\n              <Press return to execute regsfp.>\n\n');
pause
fprintf('>>regsfp\n\n')
regsfp
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('\n\nNow suppose only pendulum position and motor position\n')
fprintf('are measured.  We define the following measurement matrix:\n\n')
Cm=[1 0 0 0;0 0 1 0]
fprintf('\n\nand design a reduced-order observer using the ROO function.\n')
fprintf('Since half the state variables are measured, we use a Case 1\n')
fprintf('reduced-order observer design (see Section 7.4.2, page 291\n')
fprintf('and Table 7.7 on page 314)\n\n')
fprintf('We choose real-valued observer poles (to get decoupled estimation \n')
fprintf('error dynamics) scaled to achieve an observer\n')
fprintf('settling time of 0.25 seconds. (s1 is the normalized 1st-order Bessel pole)\n\n')
fprintf('\n     <Press return to design the reduced-order observer.>\n\n');
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('>>[F,G,H,K,P]=roo(phi,gamma,Cm,exp(T*[s1 s1]/.25))\n\n')
[F,G,H,K,P]=roo(phi,gamma,Cm,exp(T*[s1 s1]/.25));
F,G,H
fprintf('\n      <Press return to see the observer matrices K and P.>\n\n');
pause
K,P
fprintf('\n              <Press return to continue.>\n\n');
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('\n Calculate loop transfer function and check stability margins\n')
fprintf('of the reduced-order-observer-based regulator.  This is accomplished\n')
fprintf('with the function LREGROB (to compute loop transfer function of the\n')
fprintf('reduced-order-observer-based regulator, as well as the stability margins)\n\n')
fprintf('>>lregrob \n')
lregrob
fprintf('\nNotice that these stability margins are actually better than\n')
fprintf('the margins computed for the full-state feedback regulator\n')
fprintf('\n              <Press return to continue.>\n\n');
pause
fprintf('*      *       *       *       *       *       *       *       *\n\n')
fprintf('\n Simulate the behavior of the reduced-order-based\n')
fprintf('regulator with initial state x0=[0;.1;0;0] using REGROB \n\n')
x0=[0;.1;0;0];
fprintf('\n>>regrob\n\n')
regrob
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('\n Look at simulation results using REGROBP\n')
fprintf('\n>>regrobp\n')
regrobp

fprintf('\nThis demonstration is now finished.\n\n');

%___________________________ END OF DEMO1.M _______________________________


