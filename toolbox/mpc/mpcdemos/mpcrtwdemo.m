%% MPC control with output constraints

%%
% This demonstration shows how generate real-time code from a Simulink
% diagram containing MPC controllers. We consider here a single-input 
% single-output system tracking of a sinusoid under output constraints.
%
% Author: A. Bemporad
% Copyright 1990-2004 The MathWorks, Inc.  
% $Revision: 1.1.4.1 $  $Date: 2004/04/19 01:16:18 $   


%%
% We start defining the plant to be controlled
N1=[3 1];
D1=[1 2*.3 1]; 
[A,B,C,D]=tf2ss(N1,D1);
x0=[0 0]';

%%
% Now, setup an MPC controller object
Ts=.2;     %Sampling time

% Input and output constraints
MV=struct('Min',-Inf,'Max',Inf,'RateMin',-20,'RateMax',20);
OV=struct('Min',-0.5,'Max',0.5);

p=40;
m=3;

mpccon=mpc(ss(A,B,C,D),Ts,p,m,[],MV,OV);


%%
% Simulate using Simulink

Tstop=10;  %Simulation time

mpc_rtwdemo
sim('mpc_rtwdemo',Tstop)

%%
% Call RTW to compile the Simulink diagram into an executable
% Change directory to a temp directory so that you have write-permission to
% generate the relevant target files and the executable.
cwd = pwd;
cd(tempdir)
try
    rtwbuild('mpc_rtwdemo')
    % Run the executable, called mpc_rtwdemo.exe:
    status = system('mpc_rtwdemo');
end
cd(cwd)

%%
% If the build finished successfully (status=0) and if you are able to run
% the executable, you should have a data file named mpc_rtwdemo.mat in your
% temporary directory. You can load this file and compare the data with
% that generated by simulating the model mpc_rtwdemo.mdl.
%