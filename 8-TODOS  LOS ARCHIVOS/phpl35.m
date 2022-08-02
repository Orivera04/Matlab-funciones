function phpl35(ffccnn,xmin,xmax,ymin,ymax)

% PHPL35	plots a direction field for a pair of first order ordinary 
%	autonomous differential equations.  It then displays a menu 
%	in the command 
%	window, giving the user several options.  The most important 
%	options allow the user to plot the solution curves of the ode 
%	through an intial point which can either be picked off the 
%	graphics window, or can be entered on the command window.  
%	The other options are fairly self explanatory.
%
%	The user syntax is:
%	
%		phpl(F,xmin,xmax,ymin,ymax).
%
%	If the differential equations are 
%
%		x' = xpr1(t,x,y),
%		y' = xpr2(t,x,y).
%
%	Then F='xpr', and the function xpr(t,x) must be programmed in 
%	a function m-file entitled xpr.m.  The display window will be 
%	[xmin, xmax] X [ymin, ymax].
%
%	An interesting example is provided by the system of equations:
%
%			x' = x-y^2*cos(y)
%			y' = -y +x*sin(x)
%
%	To analyse this example, create the m-file curious.m, with the 
%	contents:
%
%	function xprime = curious(x)
%
%	xprime(1) = x(1) - x(2)^2*cos(x(2));
%	xprime(2) = -x(2) +x(1)*sin(x(1));
%
%	Then enter phpl('curious',-10,10,-10,10);
%
%	The differential equations are solved using the mex-file 
%	odem45.mex.  The code for this program is in the file odem45.c, 
%	which must be compiled to produce the mex file.  This program 
%	uses the Fehlberg adaptive Runge-Kutta routine that is used in 
%	ODE45, but adapted to the needs of this program.

%	Written by John C. Polking, Rice University.
%	Significant credit goes to Charles R. Denham of Mathworks, 
%	who wrote the m-file QUIVER, and to Edward Donley of Indiana 
%	University of PA, who wrote a similar program.
%

% Things yet to be done:
%   1. Done.
%
%   2.	Add the option to put a direction vector at a chosen point on 
%	the Graphics Window.
%
%   3.	Add the option to change the number of lines/vectors appearing.
%
%   4.	The menu will get complicated.  There should be an option to 
% 	not show the full menu.  This would be an expert's mode.
%
%   5.	The find equilibrium point command should be changed:
%
%		The Command Window output could be more informative.  
%		E.g., the type of equilibrium  should be printed.  
%		The jacobian is probably not important.
%
%		Experiment with labeling the points by type on the 
%		Graphics Window using the "text" command.  Alternately 
%		use different markings for different types.  A saddle 
%		point could be labeled by an "X" oriented using the 
%		eigenvectors.  Other markings could be designed for 
%		other types.
%
%		Should the information about eq. points, once calculated, 
%		be saved to speed future access?  Perhaps the user should 
% 		have the option of diisplaying the properties of all 
%		calculated eq. points.
%
%		How about a method of finding all of the eq. points in the 
%		display window with a single command?
%
%   6.	There should probably be a limit on the number of curves saved 
%	to prevent using too much memory.

printflag = 0;   % Is a special print command needed on this 
																	%	computer?  If so (e.g. for a UNIX machine)
                 % set printflag = 1.  If not (e.g. for a 
                 % Macintosh) set printflag = 0.

tolerance = 1e-6;		% This is the tolerance used in all of 
                   % the computations of solutions.
menumax = 9;
if (printflag)
		menumax =99
end

M=20;			% # of x intervals
N=M;			% # of y intervals

offset = 0.12;

LL = 3;			% Controls thhe limits of integration.

% The possible "arrows" are a direction line or a tangent vector 
% proportional in size to the gradient.

arrow1 = [-1 1].';
arrow2 = [0,1,.8,1,.8].' + [0,0,.08,0,-.08].' * sqrt(-1);

labstr = ['The differential equation x'' = ',ffccnn,'(x).'];
deltay=(ymax - ymin)/(N-1);
deltax=(xmax - xmin)/(M-1);

% We want the limits of integration to be larger than the original 
% window in order to allow zooming.

ctop = ymax+LL*(ymax-ymin);
cbottom = ymin-LL*(ymax-ymin);

cleft = xmax - LL*(xmax - xmin);
cright = xmin + LL*(xmax - xmin);

cwindow=[cleft,cright,cbottom,ctop];

% Set up the original mesh.

y=ymin + deltay*[0:N-1];
x=xmin + deltax*[0:M-1];
[xx,yy]=meshdom(x,y);

% Calculate the function on the mesh.

v=zeros(M,N);
for i = 1:M
	for j = 1:N
		xdot = feval(ffccnn,[x(i),y(j)]);
		v(j,i) = xdot(1) + xdot(2)*sqrt(-1);
	end
end
v=flipud(v);

v = v(:);

arrow=arrow1;		% The default is the direction line.

mgrid=xx+yy.*sqrt(-1);  mgrid=mgrid(:);

% We want the window a little bigger than what was called for.

wtop = ymax+deltay;
wbottom = ymin-deltay;
wleft = xmin-deltax;
wright = xmax+deltax;

window = [wleft,wright,wbottom,wtop];

axis(window);

scale = min([deltax,deltay])*0.3;
z=sign(v.');
aa  = scale*arrow1*z + ones(arrow1)*(mgrid.');
a=aa;
plot(real(a), imag(a),'-r');
grid;
title(labstr);xlabel('x');ylabel('y');

% Initiation of parameters.

trjno = 0; dirlf = 1; dirlin = 1;

disp('Enter:');
disp('   1   to see a trajectory with initial point from the screen.');
disp('   2   to see a trajectory with initial point from the keyboard.');
disp('   3   to locate an equilibrium point.');
disp('   4   to zoom in.');
disp('   5   to zoom out.');
disp('   8   to remove direction lines/vectors.');
disp('   9   to alternate lines and vectors.');
disp('  10   to plot stable and unstable orgbits.')
if (printflag)
  disp('  99   to print the graphics window.');
end
disp('   any other number to quit.');

mmm=input('');

while (~all([1 2 3 4 5 6 7 8 9 10 menumax] - mmm))
	if (~all([1 2]-mmm))	% Compute a trajectory.

	     % Get the intial point.

	     if (mmm == 1)
		     disp('Pick an initial point with the mouse.');
       disp('');
		     [x0 y0]=ginput(1);
	     else
		     x0 = input('Enter the initial value of x:');
		     y0 = input('Enter the initial value of y:');
	     end

	     % Compute the trajectory.

	     nness = (deltax +deltay)*0.005;

  	     disp('Working on the forward trajectory.');
	     [tp,xp]=pp35sol(ffccnn,[x0,y0],cwindow,1.0,nness,tolerance);
			       hold on;

	     winplot(xp(:,1),xp(:,2),window);pause(1);
	     disp('Working on the backward trajectory.');
	     [tm,xm]=pp35sol(ffccnn,[x0,y0],cwindow,-1.0,nness,tolerance);
	     	     
	     winplot(xm(:,1),xm(:,2),window);
	     hold off;


	     % Store the trajectory.

	     t=[flipud(tm);tp];
	     x=[flipud(xm);xp];
		
	     if (trjno == 0)
		     TT=t; XX=x(:,1); YY = x(:,2);
		     trjno=1;
	     else
		     % In this case we have to make sure the 
		     % trajectories fit in the same matrix.
		     [m,n]=size(TT);
		     l=length(t);
		     if (l < m)
			     t=[t;t(l)*ones(m-l,1)];
			     x=[x;ones(m-l,1)*x(l,:)];
		     elseif (m < l)
			     TT = [TT;ones(l-m,1)*TT(m,:)];
			     XX = [XX;ones(l-m,1)*XX(m,:)];
			     YY = [YY;ones(l-m,1)*YY(m,:)];
		     end
		     TT=[TT,t];
		     XX=[XX,x(:,1)];
		     YY=[YY,x(:,2)];
		     trjno = trjno + 1;
	     end
	end

	if (mmm == 3)
		disp('Choose an approximation with the mouse.');disp('');
		[x0 y0]=ginput(1);
		z = [x0,y0];

% Newton's method to find the equilibrium point.

		iterlimit = 50;
		ss=['No convergence after 50 iterations.'];
		ni=0;

		% The increment for calculating approximate derivatives.
		h=.000001;	

		functionf=feval(ffccnn,z);
		% Allow for large/small solutions.
		errorlim = norm(functionf,inf)*0.000001;  
	
		while norm(functionf,inf) > errorlim & ni < iterlimit	
    			ni = ni + 1;

% Now we calculate the jacobian.	

    			for j=1:2			
				sav = z(j);
				z(j) = z(j) + h;
				functionfhj = feval(ffccnn,z);	
				A(:,j) = (functionfhj'-functionf')/h;	
				z(j) = sav;
    			end
    			y = z' - A\(functionf');
    			z=y';		    
    			functionf = feval(ffccnn,z);
    		end
		if ni > iterlimit - 1	    
    			disp(ss);	
		else    			
			for j=1:2			
				sav = z(j);
				z(j) = z(j) + h;
				functionfhj = feval(ffccnn,z);	
				A(:,j) = (functionfhj'-functionf')/h;	
				z(j) = sav;
    			end

			disp(['An equilibrium point found at (',  num2str(z(1)),', ',num2str(z(2)),').']);
			hold on; plot(z(1),z(2),'o'); hold off;
			disp('The Jacobian is:')
			disp('')
			disp(A)
	
			disp('The eigenvalues are:')
			disp(eig(A))    
		end		
	end

	if(~all([4 5]-mmm))

		if (mmm == 4)		% Zoom in.

			disp('Pick out two opposite corners with the mouse.');disp('');
			[x1,y1] = ginput(2);
			xmin=min(x1); xmax=max(x1);
			ymin=min(y1); ymax=max(y1);

		else			% Zoom out

			xmin = input('Enter the minimum value of x: ');
			xmax = input('Enter the maximum value of x: ');
			ymin = input('Enter the minimum value of y: ');
			ymax = input('Enter the maximum value of y: ');
		end

		deltax=(xmax - xmin)/(M-1);
		deltay=(ymax - ymin)/(N-1);

		x=xmin + deltax*[0:M-1];
		y=ymin + deltay*[0:N-1];

		window=[xmin-deltax,xmax+deltax,ymin-deltay,ymax+deltay];

		axis(window);

		[xx,yy]=meshdom(x,y);

		v=zeros(M,N);
		for i = 1:M
			for j = 1:N
				xdot = feval(ffccnn,[x(i),y(j)]);
				v(j,i) = xdot(1) + xdot(2)*sqrt(-1);
			end
		end
		v=flipud(v);
		v = v(:);

		mgrid=xx+yy.*sqrt(-1);  mgrid=mgrid(:);

		if (dirlin)
			scale = min([deltax,deltay])*0.3;
			z=sign(v.');
			aa  = scale*arrow1*z + ones(arrow1)*(mgrid.');
		else
			z=v.';
			scale = 0.90*min(deltax,deltay) ./ max(max(abs(z)));
			aa  = scale*arrow2*z + ones(arrow2)*(mgrid.');
		end
		a = dirlf*aa;
		plot(real(a), imag(a),'-');
		grid;
		title(labstr);xlabel('x');ylabel('y');
		if (trjno > 0)
			hold on;
			for k=1:trjno
				winplot(XX(:,k),YY(:,k),window);
			end
			hold off
		end
	end

	if (mmm == 6)		% Erase the last trajecotry.

		if (trjno == 0)
			return
		else
			trjno = trjno - 1;
			TT=TT(:,1:trjno);
			XX=XX(:,1:trjno);
			YY=YY(:,1:trjno);
			window =[xmin-deltax,xmax+deltax,ymin-deltay,ymax+deltay];
			axis(window);
			plot(real(a), imag(a),'-');
			grid;
			title(labstr);xlabel('x');ylabel('y');
			if (trjno > 0)
				hold on;
				for k=1:trjno
					winplot(XX(:,k),YY(:,k),window);
				end
				hold off
			end
		end
	end

	if (mmm == 7)		% Erase all trajectories.

		if (trjno == 0)
			return
		else
			trjno=0;
			axis(window);
			plot(real(a), imag(a),'-');
			grid;
			title(labstr);xlabel('x');ylabel('y');
		end
	end

	if(mmm == 8)		% Toggle the arrows on and off.

		dirlf = 1-dirlf;
		a=dirlf*aa;
		axis(window);
		plot(real(a), imag(a),'-');
		grid;
		title(labstr);xlabel('x');ylabel('y');
		if (trjno > 0)
			hold on;
			for k=1:trjno
				winplot(XX(:,k),YY(:,k),window);
			end
			hold off
		end
	end

	if (mmm == 9)		% Change the shape of the arrow.

		dirlin = 1- dirlin;
		dirlf = 1;
		axis(window);
		if (dirlin)
			scale = min([deltax,deltay])*0.3;
			z=sign(v.');
			aa  = scale*arrow1*z + ones(arrow1)*(mgrid.');
		else
			z=v.';
			scale = 0.9 * min(deltax,deltay) ./ max(max(abs(z)));
			aa  = scale*arrow2*z + ones(arrow2)*(mgrid.');
		end
		a=aa;
		plot(real(a), imag(a),'-');
		grid;
		title(labstr);xlabel('x');ylabel('y');
		if (trjno > 0)
			hold on;
			for k=1:trjno
				winplot(XX(:,k),YY(:,k),window);
			end
			hold off
		end
	end

	if (mmm == 99)		% Print the graphics window.

		print;
	end

	if (mmm == 10)		% Stable/unstable curves.
		disp('Choose a saddle point with the mouse.');
		[x0 y0]=ginput(1);
		z0 = [x0,y0];
		z = z0;

% Newton's method to find the equilibrium point.

		iterlimit = 50;
		ss1=['No equilibrium point found near the point chosen.'];
		ni=0;

		% The increment for calculating approximate derivatives.
		h=.000001;	

		functionf=feval(ffccnn,z);
		% Allow for large/small solutions.
		errorlim = norm(functionf,inf)*0.000001;  
	
		while norm(functionf,inf) > errorlim & ni < iterlimit	
    			ni = ni + 1;

% Now we calculate the jacobian.	

    			for j=1:2			
				sav = z(j);
				z(j) = z(j) + h;
				functionfhj = feval(ffccnn,z);	
				A(:,j) = (functionfhj'-functionf')/h;	
				z(j) = sav;
    			end
    			y = z' - A\(functionf');
    			z=y';		    
    			functionf = feval(ffccnn,z);
    		end
		if ((ni > iterlimit - 1) | (norm(z-z0) > 5*(deltax+deltay)))
    			disp(ss1);	
		else	
			for j=1:2			
				sav = z(j);
				z(j) = z(j) + h;
				functionfhj = feval(ffccnn,z);	
				A(:,j) = (functionfhj'-functionf')/h;	
				z(j) = sav;
    			end
			[V,L] = eig(A);
			L = diag(L);
			if (L(1)*L(2) >= 0)
				disp(['The equilibrium point at (', num2str(z(1)), ', ',num2str(z(2)), ') is not a saddle point.']);
			else
	     			nness = (deltax +deltay)*0.0005;
	     			hold on;
				sgn = sign(L(1));
				w = z + offset*(deltax+deltay)*V(:,1)';
  	     			disp('Working on the trajectory.');
	     			[tp,xp]=pp35sol(ffccnn,w,cwindow,sgn,nness,tolerance);
	     			winplot(xp(:,1),xp(:,2),window,'-g');pause(1);
				w = z-offset*(deltax+deltay)*V(:,1)';
  	     			disp('Working on the trajectory.');
	     			[tp,xp]=pp35sol(ffccnn,w,cwindow,sgn,nness,tolerance);
	     			winplot(xp(:,1),xp(:,2),window,'-g');pause(1);
				sgn = sign(L(2));
				w = z + offset*(deltax+deltay)*V(:,2)';
  	     			disp('Working on the trajectory.');
	     			[tp,xp]=pp35sol(ffccnn,w,cwindow,sgn,nness,tolerance);
	     			winplot(xp(:,1),xp(:,2),window,'-g');pause(1);
				w = z-offset*(deltax+deltay)*V(:,2)';
  	     			disp('Working on the trajectory.');
	     			[tp,xp]=pp35sol(ffccnn,w,cwindow,sgn,nness,tolerance);
	     			winplot(xp(:,1),xp(:,2),window,'-g');pause(1);
				hold off;
			end
		end
	end

	% Here we have a possibly larger menu.
		
	disp('Enter:');
	disp('   1   to see a trajectory with initial point from the screen.');
	disp('   2   to see a trajectory with initial point from the keyboard.');
	disp('   3   to locate an equilibrium point.')
	disp('   4   to zoom in.');
	disp('   5   to zoom out.');
	if (trjno > 0)
		disp('   6   to erase the last trajectory.');
		disp('   7   to erase all trajectories.');
	end
	if (dirlf)
		disp('   8   to remove direction lines/vectors.');
	else
		disp('   8   to turn on direction lines/vectors.'); 
	end
	disp('   9   to alternate lines and vectors.');
 disp('  10   to plot stable and unstable orbits.');
	if (printflag)
			disp('  99   to print the graphics window.');
	end

	disp('   anything other number to quit.');

	mmm = input('');
end
hold off;

