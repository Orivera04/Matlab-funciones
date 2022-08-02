%	ROBUST1.M
%
%a.	Computes the step response
%b.	Computes the roots for Input Gain K 
%


clc
K = input('Enter a Value for OPEN LOOP Gain K,        ')

%OPEN LOOP Transfer Function
	
      %Transfer Function Numerator

	OL_num = K*[.2 1];             %K*(.2s +1)

      %Transfer Function Denumerator

	den1 = [1 0];			%s
	den2 = [.5 1];			%(.5s +1 )
	den3 = [.1 1];			%(.1s +1 )
	den23 = conv(den2,den3);	%(.05s+1)*(.1s+1)
	OL_den = conv(den1,den23);	%s(.05s+1)*(.1s+1)

      %Display Open Loop Transfer Function and Its Statistics	

	disp('OPEN LOOP TRANSFER FUNCTION:')
	printsys(OL_num, OL_den, 's');

	r_OL = roots(OL_den);		%Open Loop Roots
	r_OL = esort(r_OL);
	rr_OL = real(r_OL);
	ri_OL = imag(r_OL);
	[wn_OL,dp_OL] = damp(OL_den);	%Damping and Natural Frequencies
	OL_rl = ['Root1 Root2 Root3 Root4'];  %Row Labels
	OL_cl = ['Real  Imaginary  Damping   Frequeny']; %Column Labels
	
RLQ=menu('COMPUTE & PLOT ROOT LOCUS?...','1) YES','2) NO')

if RLQ == 1
	close
	subplot(2,1,1)
	rlocus(OL_num,OL_den);
	%axis([-12 5 -15 15]);
	title(['OPEN LOOP ROOT LOCUS (K = ', num2str(K),')']);
end
	printmat([rr_OL ri_OL dp_OL,wn_OL], 'OPEN LOOP STATISTICS',OL_rl, OL_cl);

     %FeedBack Loop Transfer Function

	H_num = [0 1];			%1
	H_den = [0 1];			%1, Unity FeedBack

%Closed Loop Transfer Function

[CL_num,CL_den] = feedback(OL_num,OL_den,H_num,H_den,-1);

   %Display Closed Loop Transfer Function and Its Statistics	
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
	%axis([-20 5 -20 20]);
	title(['CLOSED LOOP ROOT LOCUS (K = ', num2str(K),')']);
	prnt = menu('Print This Plot?','1) Yes', '2) No');
	if prnt ==1
	 orient landscape
	 print -dljet3
	 print
	end
end

%Compute Step Response

t = 0:.01:10;				%Time Vector

%OPEN LOOP Unit Step Response

	Y_open = step(OL_num, OL_den,t);

%CLOSED LOOP Unit Step Response

	Y_closed = step(CL_num, CL_den, t);

%You can Plot The Closed Loop Response Here If You Want

disp(' ');
disp('==========================================================')
