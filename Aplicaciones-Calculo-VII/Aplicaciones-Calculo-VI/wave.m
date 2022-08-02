function wave(N,dt,c)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% wave.m
%
% Solve the 1D wave equation on the unit interval using the integration
% preconditioned Chebyshev-tau method in space and BDF3 in time. 
%
% utt=c^2*uxx
%
% u(x,0)=u0(x); ut(x,0)=0; 
% u(0,t)=u(1,t)=0; 
%
% Example of usage: 
% >>wave(128,0.02,1);
%
% Reference: 
% "Integration Preconditioners for Differential Operators in Spectral 
% tau Methods" by E.A. Coutsias, T. Hagstrom, J.S. Hesthaven, D.J. Torres. 
% ( ICOSAHOM 3, 1995 / Spec. Issue Houston Journal of Mathematics - 1996)
%
% http://math.unm.edu/~vageli/papers/ico.ps
%
% Written by: Greg von Winckel - 09/04/05
% Contact: gregvw(at)math(dot)unm(dot)edu
% URL: http://math.unm.edu/~gregvw
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Velocity squared
c2=c*c;

% number of grid points
N1=N+1;

% Physical grid
x=chebnodes(N);

% Construct Chebyshev integration matrix
B=chebB(N); B2=sparse(B*B);
B2(1:2,:)=0;

I=speye(N1);

% Compute BDF3 weights for d^2/dt^2
W=ufdwt(dt,4,2);
w=W(4,:);

% Choose some intial data
u0=sech(20*x).^2;

% Store time steps here
U=zeros(N1,4);

% Transform initial data to Chebyshev modes
U(:,1)=real(fcgltran(u0,1));
U(:,2)=U(:,1); U(:,3)=U(:,2); U(:,4)=U(:,3);

% Construct Left hand side
LHS=w(4)*B2-c2*I;
LHS(1,:)=1;
LHS(2,:)=(-1).^(0:N);
LHS=sparse(LHS);

for k=1:500
   
    f=-B2*(U(:,1:3)*w(1:3)');
    f(1:2)=0; % Set right f(1) and left f(2) boundary values.
    
    % Solve for new time step
    U(:,4)=LHS\f;
    
    % Transform to point space
    u=real(fcgltran(U(:,4),-1));
    
    % Display current solution
    plot(x,u,'LineWidth',2);
    axis([-1 1 -1 1]);
    grid on;
    xlabel('x','FontSize',18);
    ylabel('u(x,t)','FontSize',18);
    title(['Wave Equation, t=',num2str((k-1)*dt)],'FontSize',18);
    
    % Update old time steps
    U(:,1)=U(:,2); U(:,2)=U(:,3); U(:,3)=U(:,4);
    
    pause(0.01);
    
end


function [x]=chebnodes(p)
x=cos(pi*(0:p)/p)';

function B=chebB(N)
band=[0 1./(2*(1:N+1))];
B=diag(band(2:N+1),-1)-diag(band(1:N),1);
B(2,1)=1;


function B=fcgltran(A,direction)
[N,M]=size(A);
if direction==1 % Nodal-to-spectral
    F=ifft([A(1:N,:);A(N-1:-1:2,:)]);
    B=([F(1,:); 2*F(2:(N-1),:); F(N,:)]);
else            % Spectral-to-nodal
    F=fft([A(1,:); [A(2:N,:);A(N-1:-1:2,:)]/2]);
    B=(F(1:N,:));
end

function W=ufdwt(h,pts,order)
N=2*pts-1;  p1=pts-1;
A=repmat((0:p1)',1,N);      B=repmat((-p1:p1)*h,pts,1);
M=(B.^A)./factorial(A); 
rhs=zeros(pts,1);   rhs(order+1)=1;
W=zeros(pts,pts);
for k=1:pts
    W(:,k)=M(:,(0:p1)+k)\rhs;
end
W=W';   W(1:pts,:)=W(pts:-1:1,:);

