%	ROBUST4.M
%	Same as Robust2.m but with a controler 1/Gc(s) in the Input
%a.	Computes the step response
%b.	Computes the roots for Input Gain K 
%


clc
K = input('Enter a Value for OPEN LOOP Gain K,        ')

%OPEN LOOP Transfer Function

  %Forward Numerator
     %Controler Transfer Function
	 %Gc_num=1; Gc_den=1;		 %No Controler Case
	 Gc_num = [1 5 100];  %(s^2+5s+100)
	 Gc_den = [100];
	
     %Plant Transfer Function Numerator
	 PL_num = K*[.4 1];             %K*(.4s +1)
     %Forward Transfer Function
	 OL_num = conv(PL_num,Gc_num);         

  %Forward Denumerator
     %Plant Denumerator
	 PL_den1 = [1 0];			%s
	 PL_den2 = [1 1];			%(s +1 )
	 PL_den3 = [.15 1];			%(.15s +1 )
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

RLQ=menu('COMPUTE & PLOT ROOT LOCUS?...','1) YES','2) NO');

if RLQ == 1
	close
	subplot(2,1,1)
	rlocus(OL_num,OL_den);
	%axis([-12 5 -15 15]);
	if (Gc_num ==1 & Gc_den==1)
          title(['Robust4: OPEN LOOP ROOT LOCUS (K = ', num2str(K),')']);
         else
	  title(['Robust4: OPEN LOOP ROOT LOCUS (K = ', num2str(K),')', ' with Controler']);
	end
end


%FeedBack Loop Transfer Function

	H_num = [0 1];			%1
	H_den = [0 1];			%1, Unity FeedBack

%Closed Loop Transfer Function

[CL_num,CL_den] = feedback(OL_num,OL_den,H_num,H_den,-1);

%Multiply CLOSED LOOP Transfer Function with the Reciprocal of Gc

  if(length(Gc_num)~=1 | length(Gc_den)~=1)
    str='Multiply Input with the Reciprocal of Controler?  ';
    GcQ = menu(str,'1) NO', '2) Yes');
     if GcQ == 2
     	CL_num = conv(Gc_den,CL_num);
	CL_den = conv(Gc_num,CL_den);	
     end
    else
      if (Gc_num ~=1 | Gc_den ~=1 )
         str='Multiply Input with the Reciprocal of Controler?  ';
         GcQ = menu(str,'1) NO', '2) Yes');
        if GcQ == 2
     	  CL_num = conv(Gc_den,CL_num);
	  CL_den = conv(Gc_num,CL_den);	
        end
       end
   end 

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
	kk=0:.5:10;
	%jrlocus(CL_num,CL_den,kk);
	
	rlocus(CL_num,CL_den);
	%axis([-12 5 -15 15]);
	%axis([-20 5 -20 20]);
        if (Gc_num ==1 & Gc_den==1)
          title(['Robust4: CLOSED LOOP ROOT LOCUS (K = ', num2str(K),')']);
         else
	  title(['Robust4: CLOSED LOOP ROOT LOCUS (K = ', num2str(K),')', ' with Controler']);
	end
	
	prnt = menu('Print This Plot?','1) Yes', '2) No');
	if prnt ==1
	 orient landscape
	 print -dcdjmono	%Change This to Reflect Your Printer
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
