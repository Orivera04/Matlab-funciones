% Script f04_06.m; plots F4 aerodynamic data and data-fit;
%                                             9/96, 4/2/02
%
M=[0:.1:1 1.2:.2:1.8];
Cd=[.013*ones(1,9) .014 .031 .041 .039 .036 .035];
Cla=[3.44*ones(1,9) 3.58 4.44 3.44 3.01 2.86 2.44];
ka=[.54*ones(1,9) .75 .79 .85 .89 .93 .93];
%
figure(1); plot(M,Cla,'x',M,100*Cd,'o',M,ka,'+')
grid; axis([0 2 0 4.5]); clear M Cla Cd ka
M=[0:.02:1.8];
for i=1:length(M), m=M(i);
if m<1.15, cd(i)=.013+.0144*(1+tanh((m-.98)/.06));
           cla(i)=3.44+1.0/(cosh((m-1)/.06))^2;
           ka(i)=.54+.15*(1+tanh((m-.9)/.06));
else cd(i)=.013+.0144*(1+tanh(.17/.06))-.011*(m-1.15); 
     cla(i)=3.44+1.0/(cosh(.15/.06))^2-(.96/.63)*(m-1.15);
     ka(i)=.54+.15*(1+tanh((.25)/.06))+.14*(m-1.15);
end; end; 
hold on; plot(M,100*cd,M,ka,M,cla); hold off;
text(.58,3.7,'Cla'); text(.58,1.6,'100*Cd');
text(.58,.75,'ka'); xlabel('Mach Number'); 
%print -deps2 \book_do\figures\f04_06