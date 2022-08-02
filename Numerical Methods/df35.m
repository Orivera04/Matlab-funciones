function [TT,XX] = df35(ffccnn,tmin,tmax,xmin,xmax)

% DF	plots a direction field for a single first order ordinary 
%	differential equation.  It then displays a menu in the command 
%	window, giving the user several options.  The most important 
%	options allow the user to plot the solution curves of the ode 
%	through an intial point which can either be picked off the 
%	graphics window, or can be entered on the command window.  
%	The other options are fairly self explanatory.
%
%	The user syntax is:
%	
%		df(F,tmin,tmax,xmin,xmax).
%
%	If the differential equation is 
%
%		x' = xpr(t,x),
%
%	Then F='xpr', and the function xpr(t,x) must be programmed in 
%	a function m-file entitled xpr.m.  The display window will be 
%	[tmin, tmax] X [xmin, xmax].
%
%	An interesting example is the equation x' = x^2 - t.  to analyse 
%	this example, create the m-file xsqmt.m, with the contents:
%
%	funtion y = xsqmt(t,x)
%
%	y = x*x -t;
%
%	Then enter df('xsqmt',-2,12,-4,4);
%
%	The differential equation is solved using the mex-file 
%	dfsolve.mex.  The code for this program is in the file dfsolve.c, 
%	which must be compiled to produce the mex file.  This program 
%	uses the Fehlberg adaptive Runge-Kutta routine that is used in 
%	ODE45, but adapted to the needs of this program.

%	Written by John C. Polking, Rice University.
%	Significant credit goes to Charles R. Denham of Mathworks, 
%	who wrote the m-file QUIVER, and to Edward Donley of Indiana 
%	University of PA, who wrote a similar program.
%

printflag = 1;   % Does the Matlab command "print" work on this
		 % computer?  If so (e.g. for a UNIX machine)
                 % set printflag = 1. 

	% If the computer is a  Macintosh set printflag = 0.

comps=computer;
if (comps(1:3) == 'MAC')
	printflag = 0;
end



tolerance = 1e-6;  % This is the tolerance used in all of 
                   % the computations of solutions.
menumax = 8;
if (printflag)
		menumax =99;
end



M=30;			% # of x intervals
N=M;			% # of t intervals

LL = 1;			% Controls thhe limits of integration.

% The possible "arrows" are a direction line or a tangent vector 
% proportional in size to the gradient.

arrow1 = [-1 1].';
arrow2 = [0,1,.8,1,.8].' + [0,0,.08,0,-.08].' * sqrt(-1);

labstr = ['The differential equation x'' = ',ffccnn,'(t,x).'];
deltat=(tmax - tmin)/(N-1);
deltax=(xmax - xmin)/(M-1);

% We want the limits of integration to be larger than the original 
% window in order to allow zooming.

tfinal = tmax+LL*(tmax-tmin);
tstart = tmin-LL*(tmax-tmin);

xtop = xmax + LL*(xmax - xmin);
xbottom = xmin - LL*(xmax - xmin);

% Set up the original mesh.

t=tmin + deltat*[0:N-1];
x=xmin + deltax*[0:M-1];
[tt,xx]=meshdom(t,x);

% Calculate the function on the mesh.

v=zeros(N,M);
for i = 1:N
	for j = 1:M
		v(j,i) = feval(ffccnn,t(i),x(j));
	end
end
vv=flipud(v);

oo=ones(v);

arrow=arrow1;		% The default is the direction line.

mgrid=tt+xx.*sqrt(-1);  mgrid=mgrid(:);

oo=oo(:);  v=vv(:);

% We want the window a little bigger than what was called for.

axis([tmin-deltat,tmax+deltat,xmin-deltax,xmax+deltax]);

scale = min([deltat,deltax])*0.3;
z=sign((oo+v.*sqrt(-1)).');
aa  = scale*arrow1*z + ones(arrow1)*(mgrid.');
a=aa;
plot(real(a), imag(a),'-r');
grid;
title(labstr);xlabel('t');ylabel('x');

% Initiation of parameters.

trjno = 0; dirlf = 1; dirlin = 1;

disp('Enter:');
disp('   1   to see a trajectory with initial point from the screen.');
disp('   2   to see a trajectory with initial point from the keyboard.');
disp('   3   to zoom in.');
disp('   4   to zoom out.');
disp('   7   to remove direction lines/vectors.');
disp('   8   to alternate lines and vectors.');
if (printflag)
	disp('  99   to print the graphics window.');
end
disp('   any other number to quit.');

mmm=input('');

while (~all([1 2 3 4 5 6 7 8 menumax] - mmm))

	if (~all([1 2]-mmm))	% Compute a trajectory.

	     % Make sure we fill the window.

	     tfinal=max(tfinal,tmax + deltat);
	     tstart=min(tstart,tmin - deltat);
	     xtop = max(xtop, xmax + deltax);
	     xbottom = min(xbottom, xmin - deltax);

	     % Get the intial point.

	     if (mmm == 1)
		     disp('Pick an initial point with the mouse.');
		     [t0 x0]=ginput(1);
	     else
		     t0 = input('Enter the initial value of t:');
		     x0 = input('Enter the initial value of x:');
	     end

	     % Compute the trajectory.

  	   disp('Working on the forward trajectory.');
	     [tp,xp]=df35sol(ffccnn,t0,tfinal,x0,xbottom,xtop,tolerance);
	     hold on;
	     plot(tp,xp,'-b');pause(1);
	     disp('Working on the backward trajectory.');
	     [tm,xm]=df35sol(ffccnn,t0,tstart,x0,xbottom,xtop,tolerance);
	     plot(tm,xm,'-b');
	     hold off;

	     % Store the trajectory.

	     t=[flipud(tm);tp];
	     x=[flipud(xm);xp];
		
	     if (trjno == 0)
		     TT=t; XX=x;
		     trjno=1;
	     else
		     % In this case we have to make sure the 
		     % trajectories fit in the same matrix.
		     [m,n]=size(TT);
		     l=length(t);
		     if (l < m)
			     t=[t;t(l)*ones(m-l,1)];
			     x=[x;x(l)*ones(m-l,1)];
		     elseif (m < l)
			     TT = [TT;ones(l-m,1)*TT(m,:)];
			     XX = [XX;ones(l-m,1)*XX(m,:)];
		     end
		     TT=[TT,t];
		     XX=[XX,x];
		     trjno = trjno + 1;
	     end
	end
	if (mmm == 3)		% Zoom in.

		disp('Pick out two opposite corners with the mouse.');
		[t1,x1] = ginput(2);
		tmin=min(t1); tmax=max(t1);
		xmin=min(x1); xmax=max(x1);
		deltat=(tmax - tmin)/(N-1);
		deltax=(xmax - xmin)/(M-1);

		t=tmin + deltat*[0:N-1];
		x=xmin + deltax*[0:M-1];

		axis([tmin-deltat,tmax+deltat,xmin-deltax,xmax+deltax]);

		[tt,xx]=meshdom(t,x);

		v=zeros(N,M);
		for i = 1:N
			for j = 1:M
				v(j,i) = feval(ffccnn,t(i),x(j));
			end
		end
		v=flipud(v);
		oo=ones(v);

		mgrid=tt+xx.*sqrt(-1);  mgrid=mgrid(:);

		oo=oo(:);  v=v(:);

		if (dirlin)
			scale = min([deltat,deltax])*0.3;
			z=sign((oo+v.*sqrt(-1)).');
			aa  = scale*arrow1*z + ones(arrow1)*(mgrid.');
		else
			z=(oo+v.*sqrt(-1)).';
			scale = 0.90*min(deltat,deltax) ./ max(max(abs(z)));
			aa  = scale*arrow2*z + ones(arrow2)*(mgrid.');
		end
		a = dirlf*aa;
		plot(real(a), imag(a),'-r');
		grid;
		title(labstr);xlabel('t');ylabel('x');
		if (trjno > 0)
			hold on;
			for k=1:trjno
				plot(TT(:,k),XX(:,k),'-b');
			end
			hold off
		end
	end

	if (mmm == 4)		% Zoom oout.

		tmin = input('Enter the minimum value of t: ');
		tmax = input('Enter the maximum value of t: ');
		xmin = input('Enter the minimum value of x: ');
		xmax = input('Enter the maximum value of x: ');
		deltat=(tmax - tmin)/(N-1);
		deltax=(xmax - xmin)/(M-1);

		t=tmin + deltat*[0:N-1];
		x=xmin + deltax*[0:M-1];
		[tt,xx]=meshdom(t,x);

		v=zeros(N,M);
		for i = 1:N
			for j = 1:M
				v(j,i) = feval(ffccnn,t(i),x(j));
			end
		end
		v=flipud(v);
		oo=ones(v);

		axis([tmin-deltat,tmax+deltat,xmin-deltax,xmax+deltax]);
		mgrid=tt+xx.*sqrt(-1);  mgrid=mgrid(:);

		oo=oo(:);  v=v(:);
		if (dirlin)
			scale = min([deltat,deltax])*0.3;
			z=sign((oo+v.*sqrt(-1)).');
			aa  = scale*arrow1*z + ones(arrow1)*(mgrid.');
		else
			z=(oo+v.*sqrt(-1)).';
			scale = 0.90*min(deltat,deltax) ./ max(max(abs(z)));
			aa  = scale*arrow2*z + ones(arrow2)*(mgrid.');
		end
		a = dirlf*aa;
		plot(real(a), imag(a),'-r');
		grid;
		title(labstr);xlabel('t');ylabel('x');
		if (trjno > 0)
			hold on;
			for k=1:trjno
				plot(TT(:,k),XX(:,k),'-b');
			end
			hold off
		end
	end

	if (mmm == 5)		% Erase the last trajecotry.

		if (trjno == 0)
			return
		else
			trjno = trjno - 1;
			TT=TT(:,1:trjno);
			XX=XX(:,1:trjno);
			axis([tmin-deltat,tmax+deltat,xmin-deltax,xmax+deltax]);
			plot(real(a), imag(a),'-r');
			grid;
			title(labstr);xlabel('t');ylabel('x');
			if (trjno > 0)
				hold on;
				for k=1:trjno
					plot(TT(:,k),XX(:,k),'-b');
				end
				hold off
			end
		end
	end

	if (mmm == 6)		% Erase all trajectories.

		if (trjno == 0)
			return
		else
			trjno=0;
			axis([tmin-deltat,tmax+deltat,xmin-deltax,xmax+deltax]);
			plot(real(a), imag(a),'-r');
			grid;
			title(labstr);xlabel('t');ylabel('x');
		end
	end

	if(mmm == 7)		% Toggle the arrows on and off.

		dirlf = 1-dirlf;
		a=dirlf*aa;
		axis([tmin-deltat,tmax+deltat,xmin-deltax,xmax+deltax]);
		plot(real(a), imag(a),'-r');
		grid;
		title(labstr);xlabel('t');ylabel('x');
		if (trjno > 0)
			hold on;
			for k=1:trjno
				plot(TT(:,k),XX(:,k),'-b');
			end
			hold off
		end
	end

	if (mmm == 8)		% Change the shape of the arrow.

		dirlin = 1- dirlin;
		dirlf = 1;
		axis([tmin-deltat,tmax+deltat,xmin-deltax,xmax+deltax]);
		if (dirlin)
			scale = min([deltat,deltax])*0.3;
			z=sign((oo+v.*sqrt(-1)).');
			aa  = scale*arrow1*z + ones(arrow1)*(mgrid.');
		else
			z=(oo+v.*sqrt(-1)).';
			scale = 0.9 * min(deltat,deltax) ./ max(max(abs(z)));
			aa  = scale*arrow2*z + ones(arrow2)*(mgrid.');
		end
		a=aa;
		plot(real(a), imag(a),'-r');
		grid;
		title(labstr);xlabel('t');ylabel('x');
		if (trjno > 0)
			hold on;
			for k=1:trjno
				plot(TT(:,k),XX(:,k),'-b');
			end
			hold off
		end
	end

	if (mmm == 99)		% Print the graphics window.

		print;
	end

	% Here we have a possibly larger menu.
		
	disp('Enter:');
	disp('   1   to see a trajectory with initial point from the screen.');
	disp('   2   to see a trajectory with initial point from the keyboard.');
	disp('   3   to zoom in.');
	disp('   4   to zoom out.');
	if (trjno > 0)
		disp('   5   to erase the last trajectory.');
		disp('   6   to erase all trajectories.');
	end
	if (dirlf)
		disp('   7   to remove direction lines/vectors.');
	else
		disp('   7   to turn on direction lines/vectors.'); 
	end
	disp('   8   to alternate lines and vectors.');
	if (printflag)
		disp('  99   to print the graphics window.');
	end
	disp('   anything other number to quit.');

	mmm = input('');
end
hold off;

