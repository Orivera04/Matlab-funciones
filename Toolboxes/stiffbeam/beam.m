
clear all; close all; 

verf = menu('Verfahren',...
						'Euler explizit',...
						'Euler modifiziert',...
						'Heun',...
						'klass. RK4 (explizit)',...
						'Hammer & Hollingsworth 4 (implizit); Inner Iteration',...
						'Hammer & Hollingsworth 4 (implizit); Newton Iteration',...
						'Adams-Bashforth 4',...
						'Adams-Moulten 4',...
						'Adams-Bashforth-Moulton 4',...
						'BDF-Verfahren 4 (innere Iterationen)',...		
						'BDF-Verfahren 4 (Newton-Iterationen)',...
						'BDF-Verfahren 2 (innere Iterationen)',...
						'BDF-Verfahren 2 (Newton-Iterationen)');


% $$$ Hallo Faisal,
% $$$ 
% $$$ The following parameters you should add to the GUI to be chosen:
% $$$ 
% $$$ Space Discretization: S (default value S=8)
% $$$ Final Time T (default value T=5)
% $$$ Time steps n (default value depends from the chosen method: 
% $$$               see paper)
% $$$ 							
% $$$ Thank you very much for your work
% $$$ 	
% $$$ Best regards,
% $$$ Stefan



% Anzahl der Ortsdiskretisierung
S = 8;
% Gleichung
equation = 'BEAMODE';
% Parameter
% Zeitintervall
T = 2;
time = [0; 0];
time(2) = T;



% Anfangsbedingungen
y0 = zeros(S,1);
%y0(S,1) = 0.4; %modifizierte AB, welche zu Oszillationen führt
v0 = zeros(S,1);

% Anzahl der Schritte
%n = 50000;
n = 560;
plott = 10;
%plott = 100;

% Anfangszeitpunkt
tt(1) = time(1);

% Schrittweite
h = (time(2)-time(1))/n;
% Anfangswerte
y = [y0; v0];

% Anfangskoordinaten berechnen
dS = 1/S; 
xxold(1) = 0; yyold(1) = 0; 
for j = 1 : S
	xxold(j+1) = xxold(j) + dS*cos(y(j,1));
	yyold(j+1) = yyold(j) + dS*sin(y(j,1));
end

% Grafikkonfiguration setzen
figure(1);
clf;

%plot3(tt(1)*ones(1,S+1),yyold,xxold,'k-');

wave_plot = plot3(tt(1)*ones(1,S+1),yyold,xxold,'k-');grid
%set(wave_plot,'Erase','XOR')
%axis([res2(1),res2(length(res2)),a,b,-1.5,1.5]);

set(gca,'YDir','reverse')
axis off;
view([-5,-5,6])
set(gca,'CameraViewAngleMode','Manual')

% Löser für Einschrittverfahren
if verf <= 6
	for k = 1:n
		tt(k+1) = time(1) + k*h;
		switch verf
		 case 1
			y(:,k+1) = EULER(equation, tt(k), y(:,k), h, '');
		 case 2
			y(:,k+1) = EULERMOD(equation, tt(k), y(:,k), h, '');
		 case 3
			y(:,k+1) = HEUN(equation, tt(k), y(:,k), h, '');
		 case 4
			y(:,k+1) = RK4(equation, tt(k), y(:,k), h, '');
		 case 5
			[y(:,k+1), ll(k)] = RK4IMPL(equation, tt(k), y(:,k), h, '');
		 case 6
			[y(:,k+1), ll(k)] = RK4IMPL_NEWTON(tt(k), y(:,k), h, '');
		end
		
		% Berechnung der (x,y)-Punkte
		if (mod(k,plott) == 0) | (k==n)
			xx(1) = 0; yy(1) = 0;
			for j = 1 : S
				xx(j+1) = xx(j) + dS*cos(y(j,k));
				yy(j+1) = yy(j) + dS*sin(y(j,k));
			end
			
			hold on
			help = ones(1,S+1);
			x_plot = [tt(k-plott+1)*help, tt(k+1)*help];
            y_plot = [yyold, yy(S+1:-1:1)];
            z_plot = [xxold, xx(S+1:-1:1)];
            %patch([tt(k-plott+1)*help, tt(k+1)*help],...
					%[yyold, yy(S+1:-1:1)],[xxold, xx(S+1:-1:1)],...
						%[0.7, 1.0, 0.7]);
            %set(wave_plot,'XDATA',tt(k-plott+1)*help,...
            %    'YDATA',yy(S+1:-1:1),'ZDATA',xx(S+1:-1:1),'LineWidth',2);
            fill3(x_plot,y_plot,z_plot,[0.7, 1.0, 0.7])
            
            
            %drawnow;
            %pause(0.01)        
                    
			yyold = yy;
			xxold = xx;
			pause(0.05);
		end
	end
end;


if (verf==12) | (verf==13) 
	anlaufstep = 4;
else
	anlaufstep = 4;
end

% Löser für Mehrschrittverfahren
if verf > 6
	fvec = zeros(size(y,1),n+1);
	fvec(:,1) = feval(equation, tt(1), y(:,1), '');	
	% Anlaufrechnung
	for i = 1:anlaufstep
		tt(i+1) = time(1) + i*h;
    y(:,i+1) = RK4(equation, tt(i), y(:,i), h, '');
		tt(i+1) = time(1) + i*h;
		fvec(:,i+1) = feval(equation, tt(i), y(:,i+1),'');
  end
	
	% Berechnung der (x,y)-Punkte
		if (mod(i,plott) == 0) | (i==n)
			xx(1) = 0; yy(1) = 0;
			for j = 1 : S
				xx(j+1) = xx(j) + dS*cos(y(j,i));
				yy(j+1) = yy(j) + dS*sin(y(j,i));
			end
			
			hold on
			help = ones(1,S+1);
			patch([tt(i-plott+1)*help, tt(i+1)*help],...
					[yyold, yy(S+1:-1:1)],[xxold, xx(S+1:-1:1)],...
						[0.7, 1.0, 0.7]);
			yyold = yy;
			xxold = xx;
			pause(0.05);
		end
	
	for i = anlaufstep+1:n
		tt(i+1) = time(1) + i*h;
		switch verf
		 case 7
			y(:,i+1) = AB4(y(:,i), fvec(:,i-3:i), h);
			fvec(:,i+1) = feval(equation, tt(i+1), y(:,i+1), '');
		 case 8
			yp = AB4(y(:,i), fvec(:,i-3:i), h);
			fvec(:,i+1) = feval(equation, tt(i+1), yp,'');
			[y(:,i+1), l] = AM4(equation, tt(i+1), y(:,i), fvec(:,i-2:i+1), ...
													h, []);
			fvec(:,i+1) = feval(equation, tt(i+1), y(:,i+1), '');
		 case 9
			yp = AB4(y(:,i), fvec(:,i-3:i), h);
			fvec(:,i+1) = feval(equation, tt(i+1), yp,'');
			y(:,i+1) = ABM4(y(:,i), fvec(:,i-2:i+1), h);
			fvec(:,i+1) = feval(equation, tt(i+1), y(:,i+1), '');
		 case 10
			[y(:,i+1), ll(i)] = BDF4(equation, tt(i), y(:,i-3:i), h, []);
		 
		 case 11
			[y(:,i+1), ll(i)] = BDF4_NEWTON(equation, tt(i), y(:,i-3:i), h, ...
																			[]);
			
		 case 12
			[y(:,i+1), ll(i)] = BDF2(equation, tt(i), y(:,i-1:i), h, ...
															 []);
		 case 13
			[y(:,i+1), ll(i)] = BDF2_NEWTON(equation, tt(i), y(:,i-1:i), h, ...
																			[]);
		end
		
		% Berechnung der (x,y)-Punkte
		if (mod(i,plott) == 0) | (i==n)
			xx(1) = 0; yy(1) = 0;
			for j = 1 : S
				xx(j+1) = xx(j) + dS*cos(y(j,i));
				yy(j+1) = yy(j) + dS*sin(y(j,i));
			end
			
			hold on
			help = ones(1,S+1);
			patch([tt(i-plott+1)*help, tt(i+1)*help],...
					[yyold, yy(S+1:-1:1)],[xxold, xx(S+1:-1:1)],...
						[0.7, 1.0, 0.7]);
			yyold = yy;
			xxold = xx;
			pause(0.05);
		end
	end
end;

return

%if (verf==5) |  (verf==6) | (verf==10) | (verf==11) | (verf==12) | (verf==13) 
%	figure(2);
	clf; box on;
	%title([num2str(n),' Zeitschritte'],'FontSize',32,'Color','b');
	hold on;
	%axis([1 n 0 75]);
	plot([1:n],ll,'r-','Linewidth',5,...
			 'MarkerFaceColor','r','MarkerSize',5);
	set(gca,'FontSize',24);
	xlabel('Schritte','FontSize',18);
	ylabel('Anzahl der Newton Iterationen','FontSize',18);
end


	




