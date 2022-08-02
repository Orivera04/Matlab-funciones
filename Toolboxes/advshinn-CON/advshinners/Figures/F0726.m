%	ROBUST2.M
%	Same as Robust1.m but with a controler Gc(s) in the Closed Loop
%a.	Computes the step response
%b.	Computes the roots for Input Gain K 
%


clc
K = input('Enter a Value for OPEN LOOP Gain K,        ')

%OPEN LOOP Transfer Function
  %Forward Numerator
	%Controler Transfer Function
	 Gc_num = [1 6.4523 144.2046];  %(s^2+6.4523s+144.2046)
	 Gc_den = [144.2046];
	%Plant Transfer Function Numerator
	 PL_num = K*[.2 1];             %K*(.2s +1)
	%Forward Transfer Function
	 OL_num = conv(PL_num,Gc_num);         

  %Forward Denumerator
	%Plant Denumerator
	 PL_den1 = [1 0];			%s
	 PL_den2 = [.5 1];			%(.5s +1 )
	 PL_den3 = [.1 1];			%(.1s +1 )
	 PL_den23 = conv(PL_den2,PL_den3);	%(.05s+1)*(s+1)
	 OL_den = conv(PL_den1,PL_den23);	%(.2s+1)*.05s+1)*(s+1)
	 OL_den = conv(Gc_den,OL_den);

%Display Open Loop Transfer Function and its Statistics

	disp('OPEN LOOP TRANSFER FUNCTION:')
	printsys(OL_num, OL_den, 's');

	r_OL  = roots(OL_den);		%Open Loop Roots
	r_OL  = esort(r_OL);
	rr_OL = real(r_OL);
	ri_OL = imag(r_OL);
	[wn_OL,dp_OL] = damp(OL_den);	%Damping and Natural Frequencies
	OL_rl = ['Root1 Root2 Root3 Root4 Root5'];  %Row Labels. Increase if More Roots
	OL_cl = ['Real  Imaginary  Damping   Frequeny']; %Column Labels
	printmat([rr_OL ri_OL dp_OL,wn_OL], 'OPEN LOOP STATISTICS',OL_rl, OL_cl);

RLQ=menu('COMPUTE & PLOT ROOT LOCUS?...','1) YES','2) NO')

if RLQ == 1
	close
	subplot(2,1,1)
	rlocus(OL_num,OL_den);
	axis([-12 5 -15 15]);
	title(['Robust2: OPEN LOOP ROOT LOCUS (K = ', num2str(K),')']);
end


%FeedBack Loop Transfer Function

	H_num = [0 1];			%1
	H_den = [0 1];			%1, Unity FeedBack

%Closed Loop Transfer Function

[CL_num,CL_den] = feedback(OL_num,OL_den,H_num,H_den,-1);

%Display Open Loop Transfer Function and its Statistics	
	disp('');
	disp('CLOSED LOOP TRANSFER FUNCTION:')
	printsys(CL_num, CL_den, 's');
	r_CL = roots(CL_den);		%Closed Loop Roots
	r_CL = esort(r_CL);
	rr_CL= real(r_CL);
	ri_CL= imag(r_CL);
	[wn_CL,dp_CL] = damp(CL_den);	%Damping and Natural Frequencies
	CL_rl = ['Root1 Root2 Root3 Root4 Root5 Root6 Root7'];  %Row Labels
	CL_cl = ['Real Imaginary  Damping   Frequeny']; %Column Labels
	printmat([rr_CL ri_CL dp_CL,wn_CL], 'CLOSED LOOP STATISTICS',CL_rl, CL_cl);

if RLQ == 1
	subplot(2,1,2);
	rlocus(CL_num,CL_den);
	axis([-12 5 -15 15]);
	%axis([-20 5 -20 20]);
	title(['Robust2: CLOSED LOOP ROOT LOCUS (K = ', num2str(K),')']);
	prnt = menu('Print This Plot?','1) Yes', '2) No');
	if prnt ==1
	 orient landscape
	 print -dcdjmono	%Change This to Reflect Your Printer
	 print
	end
end

%Compute Unit Step Response

t = 0:.01:10;				%Time Vector

%OPEN LOOP Unit Step Response

	Y_open = step(OL_num, OL_den,t);

%CLOSED LOOP Unit Step Response

	Y_closed = step(CL_num, CL_den, t);

disp(' ');
disp('==========================================================')
