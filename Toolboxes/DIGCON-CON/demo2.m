% DEMO2	Demonstration script: multivariable digital tracking system.
%
%	DEMO2 uses the State Space Digital Control Toolbox to design,
%	analyze, and simulate multivariable digital tracking systems
%	for an aircraft. Both full-state feedback and observers are shown.

% R.J. Vaccaro 1/95


fprintf('\n\n\nIn this example we design a multivariable tracking system\n') 
fprintf('for an experimental aircraft (see Example 9.10, page 404 in the textbook). \n') 
fprintf('\nThe plant model represents the longitudinal dynamics as perturbed\n') 
fprintf('from steady-state straight and level trim conditions, with a nominal\n') 
fprintf('velocity of 881 ft/sec.  A state-space model is shown below:\n')
fprintf('\n        <Press return to see the state-space model.>\n\n')
pause

A=[      0         0         0    1.0000
  -32.1000   -0.0822    0.0472  -19.7000
   -0.7050   -0.0558   -1.6800  898.0000
         0   -0.0032    0.0303   -0.2530]
b=[         0         0         0
   20.5700   -2.7459    0.1250
  -36.3300 -115.0000   -4.263e-3
   30.1950   -3.7240   -2.773e-4]
fprintf('\n             <Press return to see the output matrix.>\n\n')
pause
c=[ 1.0000         0         0         0
    1.0000    2.45e-5   -1.12e-3       0
         0    1.0000    0.0219         0]
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('In what follows, all angles are measured in degrees.\n\n')
fprintf('The state variables are\n\n')
fprintf('     x_1  = roll angle\n')
fprintf('     x_2  = perturbation velocity in x direction\n')
fprintf('     x_3  = velocity in z direction\n')
fprintf('     x_4  = roll rate\n\n')
fprintf('The inputs are\n\n')
fprintf('     u_1  = canard angle\n')
fprintf('     u_2  = flaperon angle\n')
fprintf('     u_3  = thrust (pounds).\n\n')
fprintf('The outputs to be controlled are\n\n')
fprintf('     y_1 = pitch angle\n')
fprintf('     y_2 = flight-path angle\n')
fprintf('     y_3 = aircraft velocity (ft/sec).\n\n')
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('The desired settling time for a step change in any output is\n') 
fprintf('T_S = 2 seconds.  For this example we choose a sampling interval\n') 
fprintf('of T = T_S/100 = 0.02 seconds.  The ZOH equivalent for this system is\n')
fprintf('calculated using the ZOHE function, [phi,gamma]=zohe(A,b,T).\n')
T=.02;
[phi,gamma]=zohe(A,b,T)
fprintf('\n                   <Press return to continue.>\n')
pause
fprintf('\nWe now design a multivariable digital tracking system using\n')
fprintf('the procedure shown in Table 9.3, page 402 of the book\n')
fprintf('\nStep 1\n\n')
fprintf('In order to track step inputs, the matrix A_r=0.  The pole at\n')
fprintf('s=0 maps into the z plane as a pole at z=1.  The polynomial\n')
fprintf('delta(z) = z-1 and the additional dynamics are\n')
phia=1,gammaa=1
fprintf('\n                   <Press return to continue.>\n')
pause
fprintf('\nStep 2\n\n')
fprintf('\nBecause the plant has three outputs, we replicate the\n')
fprintf('additional dynamics into three parallel systems described\n') 
fprintf('by the model\n')
phia=eye(3),gammaa=eye(3)
fprintf('\n                   <Press return to continue.>\n')
pause
fprintf('\nStep 3\n\n')
fprintf('The design model is the cascade combination of the ZOH of the plant\n')
fprintf('and the replicated additional dynamics.  The state-space matrices for\n')
fprintf('the design model are\n')
fprintf('\n             |   phi      0   |             | gamma |\n')
fprintf('     phi_d = |                |,  gamma_d = |       |\n')
fprintf('             | gammaa*c  phia |             |   0   |\n\n')
fprintf('In order to choose the closed-loop poles, we first compute the\n')
fprintf('eigenvalues of the Ab matrix of the plant.  These eigenvalues are\n')
fprintf('\n   -6.2364, 4.3068, -0.0428+j 0.0806, -0.0428-j 0.0806.\n\n')
fprintf('The pole at s=-6.2364 is well damped, and we will keep it as a \n')
fprintf('closed-loop pole.  We add damping to the complex conjugate poles\n') 
fprintf('to achieve a settling time of 2 seconds. These desired closed-loop \n')
fprintf('poles are at -4.6/2+j0.0806, -4.6/2-j*0.0806.\n')
fprintf('\n                   <Press return to continue.>\n')
pause

fprintf('\nBecause the design model is 7th-order, there are four more \n')
fprintf('closed-loop poles to choose.  We will put them on the real\n') 
fprintf('axis at the following locations (corresponding to a settling\n')
fprintf('time of about 2 seconds): -2.3, -2.4, -2.5, -2.6.\n')
fprintf('Thus the complete set of s-plane closed-loop poles is\n')
fprintf('\n   -6.2364, -2.3 +/- j0.0806, -2.3, -2.4, -2.5, -2.6.\n')
fprintf('\nThese poles are mapped into the z plane using the ZOH \n')
fprintf('pole-mapping formula, z=exp(s*T), to obtain the following\n')
fprintf('desired z-plane closed-loop poles:\n')
fprintf('\n 0.8827, 0.9550 +/- j0.0015, 0.9550, 0.9531,0.9512, 0.9493.\n')
fprintf('\nThe feedback gain matrix for the design model can be calculated\n')
fprintf('using the FBG function.  However, the complete digital state-feedback\n')
fprintf('tracking system can be designed using the DTS function (DTS calls\n')
fprintf('FBG) as follows (note that DTS forms the matrices phia and gammaa\n')
fprintf('which were shown previously) \n')
fprintf('\n           <Press return to execute the DTS function.>\n')
pause
fprintf('\n>>[phia,gammaa,L1,L2]=dts(phi,gamma,c,1,exp(T*spoles))\n')
spoles=[-6.2364  -2.3+j*0.0806 -2.3-j*0.0806 -2.3 -2.4 -2.5 -2.6];
[phia,gammaa,L1,L2]=dts(phi,gamma,c,1,exp(T*spoles));
j=sqrt(-1);
L1,L2
fprintf('The feedback gain matrix computed for the design system \n')
fprintf('(phi_d,gamma_d) has 7 columns, and is partitioned into two matrices.\n')
fprintf('L1 consists of the first 4 columns (plant is 4th order), and\n')
fprintf('L2 consists of the last 3 columns (additional dynamics are 3rd order).\n')
fprintf('\n                   <Press return to continue.>\n\n')
pause
fprintf('\nWe can calculate the loop transfer function for this tracking\n')
fprintf('system and find its stability margins using the following command:\n')
fprintf('\n>>ltssf\n')
ltssf
fprintf('\n                   <Press return to continue.>\n')
pause
fprintf('\nThese stability margins are adequate, and we now check the transient\n')
fprintf('response for a pitch pointing maneuver of the aircraft. This\n')
fprintf('maneuver is described as follows: the aircraft is flying straight\n')
fprintf('and level at a given velocity, and a step input of 2 degrees in the\n')
fprintf('in the pitch angle y_1 is given while the other two outputs are\n')
fprintf('commanded to remain unchanged.  The reference inputs for y_1, y_2,\n')
fprintf('and y_3 can be generated as a single vector-signal using SIGGEN:\n')
fprintf('\nref=siggen([2 0 0 0 0 0 0 0 0],ftime,T);\n')
fprintf('\nwhere ftime has been set to 5 (simulate for 5 seconds), and T is \n')
fprintf('the sampling interval.  We set the initial state of the plant to zero.\n')
fprintf('The terms involving the disturbance input are set to zero by TSSF if\n')
fprintf('they are not defined by the user.\n')
fprintf('\n>>dist=siggen([0 0 0],ftime,T);\n')
ftime=5;
x0=[0 0 0 0]';
ref=siggen([2 0 0 0 0 0 0 0 0],ftime,T);
fprintf('\n                   <Press return to continue.>\n')
pause
fprintf('\nWe can now simulate the behavior of this full-state-feedback\n')
fprintf('tracking system using the TSSF script\n')
fprintf('\n>>tssf\n\n')
clear f fm g dist e
tssf
fprintf('\nThe results of the simulation can be seen using the TSSFP plotting script\n')
fprintf('Look at Output #1 to see the 2 degree step reponse.  Also look at\n')
fprintf('Output #2 and #3 to see that they have very little response to the\n')
fprintf('command for Output #1\n')
tssfp
fprintf('\nIf only the plant outputs are measured, we can use a reduced-order\n')
fprintf('observer to estimate the state vector.  The observer is designed using\n')
fprintf('the ROO function to have a settling time of 0.5 seconds:\n')
fprintf('\n>>[F,G,H,K,P]=roo(phi,gamma,Cm,exp(-4.62*T/.5))\n')
fprintf('\nwhere Cm=c, the output matrix of the plant\n')
Cm=c;
[F,G,H,K,P]=roo(phi,gamma,c,exp(-4.62*T/.5));
F,G
fprintf('\n       <Press return to see the observer matrices H, K, and P.>\n')
pause
H,K,P
fprintf('\n                   <Press return to continue.>\n')
pause
fprintf('\nThe loop transfer function of the tracking system with the reduced-order\n')
fprintf('observer, as well as the stability margins, can be calulated using the\n')
fprintf('LTSROB function.\n')
fprintf('\n>>ltsrob\n')
ltsrob
fprintf('\n                   <Press return to continue.>\n')
pause
fprintf('\nIf you would like to simulate the behavior of the reduced-order-observer\n')
fprintf('based tracking system, type "tsrob" \n')
clear e f g fm dist
fprintf('\nThis demonstration is now finished.\n\n');

%___________________________ END OF DEMO2.M _______________________________


