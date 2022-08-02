function [q,t,R,A,I,t1,t2,s,p,q0,q1,q2]=finance...
                          (R,A,I,t1,t2,s,p,q0,q2)
% [q,t,R,A,I,t1,t2,s,p,q0,q1,q2]=finance...
%                         (R,A,I,t1,t2,s,p,q0,q2)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function solves the SAVE-SPEND PROBLEM
% where funds earning interest are accumulated
% during one period and paid out in a subsequent
% period. The value of assets is adjusted to 
% account for inflation. This problem is
% governed by the differential equation
% q'(t)=r*q(t)+[s*(t<=t1)...
%       -p*(t>t1)*exp(-a*t1)]*exp(a*t) where
% r=R-I, a=A-I and the remaining parameters
% are defined below

% User m functions required: inputv, savespnd

disp(' '), disp(['    ',...
'ANALYSIS OF THE SAVE-SPEND PROBLEM BY SOLVING'])
disp(...
['q''(t)=r*q(t)+[s*(t<=t1)-p*(t>t1)*',...
	'exp(-a*t1)]*exp(a*t)']), disp(...
'where r=R-I, a=A-I, and q(0)=q0'), disp(' ')

% Create a character variable containing
% definitions of input and output quantities
explain=char('INPUT QUANTITIES:',...
'R   - annual percent earnings on assets',...
'I   - annual percent inflation rate',...
'A   - annual percent increase in savings',...
'      to offset inflation',...
'r,a - inflation adjusted values of R and I',...
't1  - saving period (years), 0<t<t1',...
't2  - payout period (years), t1<t<(t1+t2)',...
's   - saving rate at t=0, ($K). Saving is',...
'      expressed as s*exp(a*t),  0<t<t1',...
'p   - payout rate at t=t1, ($K). Payout is',...
'      expressed as',...
'      -p*exp(a*(t-t1)), t1<t<(t1+t2)',...
'q0  - initial savings at t=0, ($K)',...
'q2  - final savings at t=T2=t1+t2, ($K)',' ',...
'OUTPUT QUANTITIES:',...
'q  -  vector of inflation adjusted savings',...
'      values for 0 <= t <= (t1+t2)',...
't  - vector of times (years) corresponding',...
'     to the components of q',...
'q1 - value of savings at t=t1, when the',...
'     saving period ends',' ');

% NOTE: WHEN R,I,A,T1,T2 ARE KNOWN,THEN FIXING
% ANY THREE OF THE VALUES q0,s,p,q2 DETERMINES
% THE UNKNOWN VALUE WHICH SHOULD BE GIVEN AS
% nan IN THE DATA INPUT.

% Read data interactively when input data is not
% passed through the call list
if nargin==0  
  disp('To list parameter definitions enter y')
	querry=input('otherwise enter n  ? ','s');
	if querry=='Y' | querry=='y'
		disp(explain); disp('Press return to continue')
		pause, disp(' ')
	end
	
	% Read multiple variables on the same line
    [R,A,I]=inputv('Input R,A,I (try 11,4,4) ? '); 
  	[t1,t2]=inputv('Input t1,t2 (try 40,20) ? ');
	while 1
	  [q0,s,p,q2]=inputv(...
	  'Input q0,s,p,q2 (try 20,5,nan,40) ? ');
    if sum(isnan([q0,s,p,q2]))==1, break; end
	  fprintf(['\nDATA ERROR. ONE AND ONLY ',...
      'ONE VALUE AMONG\n','THE PARAMETERS ',...
      'q0,s,p,q2 CAN EQUAL nan \n\n'])
  end
end

nt=101; T2=t1+t2; r=(R-I)/100; a=(A-I)/100;
c0=exp(r*T2); 

% q0,s,p,q2 are related by q2=c0*q0+c1*s+c2*p
% Check special case where t1 or t2 are zero
if t1==0
	disp(' '), disp('s is set to zero when t1=0')
  s=0; c1=0;
else
	c1=savespnd(T2,t1,0,R,A,I,1,0);
end 

if t2==0
	disp(' '), disp('p is set to zero when t2=0')
  p=0; c2=0;
else
	c2=savespnd(T2,t1,0,R,A,I,0,1);
end

if t1==0 | t2==0
	t=linspace(0,T2,nt)';
else
   n1=max(2,fix(t1/T2*nt));
   n2=max(2,nt-n1)-1;
   t=[t1/n1*(0:n1),t1+t2/n2*(1:n2)]';
end

% Solve for the unknown parameter
if isnan(q0),    q0=(q2-s*c1-p*c2)/c0;
elseif isnan(s), s=(q2-q0*c0-p*c2)/c1;
elseif isnan(p), p=(q2-q0*c0-s*c1)/c2;
else,            q2=q0*c0+s*c1+p*c2;
end

% Compute results for q(t)
q=savespnd(t,t1,q0,R,A,I,s,p); 
q1=savespnd(t1,t1,q0,R,A,I,s,p);

% Print formatted results
b=inline('blanks(j)','j'); B=b(3); d='%8.3f';
u=[d,B,d,B,d,B,d,B,d,'\n']; disp(' ')
disp([b(19),'PROGRAM RESULTS'])
disp(['    t1         t2         R',...
	  '        	 A          I'])
fprintf(u,t1,t2,R,A,I), disp(' ')
disp(['    q0         q1         q2',...
		  '         s          p'])
fprintf(u,q0,q1,q2,s,p), disp(' '), pause(1)

% Show results graphically
close; plot(t,q,'k')
title(['INFLATION ADJUSTED SAVINGS WHEN ',...
 'S = ',num2str(s),' AND P = ',num2str(p)]);
titl=...
['TOTAL SAVINGS WHEN  T1 = ',num2str(t1),...
',  T2 = ',num2str(t2),', s = ',num2str(s),...
',  p = ',num2str(p)]; title(titl)

xlabel('TIME IN YEARS') 
ylabel('TOTAL SAVINGS IN $K')

% Character label showing data parameters
label=char(...
 sprintf('R  = %8.3f',R),...
 sprintf('I   = %8.3f',I),...
 sprintf('A  = %8.3f',A),... 
 sprintf('q0 = %8.3f',q0),...
 sprintf('q1 = %8.3f',q1),...
 sprintf('q2 = %8.3f',q2));
w=axis; ymin=w(3); dy=w(4)-w(3);
xmin=w(1); dx=w(2)-w(1);
ytop=ymin+.8*dy; Dy=.065*dy;
xlft=xmin+0.04*dx;
text(xlft,ytop,label)
grid off,  shg

%=============================================

function q=savespnd(t,t1,q0,R,A,I,s,p)
%
% q=savespnd(t,t1,q0,R,A,I,s,p)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% This function determines q(t) satisfying
% q'(t)=r*q+[s*(t<=t1)-p*(t>t1)*...
% exp(-a*t1)]*exp(a*t), with q(0)=q0, 
% r=(R-I)/100; a=(A-I)/100

r=(R-I)/100; a=(A-I)/100; c=r-a; T=t-t1;
if r~=a
   q=q0*exp(r*t)+s/c*(exp(r*t)-exp(a*t))...
      -(p+s*exp(a*t1))/c*(T>0).*(...
      exp(r*T)-exp(a*T));
else % limiting case as a=>r
   q=q0*exp(r*t)+s*t.*exp(r*t)...
      -(p+s*exp(r*t1)).*T.*(T>0).*exp(r*T);
end

%=============================================	
	
function varargout=inputv(prompt)
%
% [a1,a2,...,a_nargout]=inputv(prompt)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function reads several values on one
% line. The items should be separated by
% commas or blanks.
%
% prompt              - A string preceding the 
%                       data entry.  It is set
%                       to ' ? ' if no value of
%                       prompt is given.
% a1,a2,...,a_nargout - The output variables 
%                       that are created. If 
%                       not enough data values
%                       are given following the
%                       prompt, the remaining
%                       undefined values are 
%                       set equal to NaN
%
% A typical function call is:
% [A,B,C,D]=inputv('Enter values of A,B,C,D: ')
%
% ---------------------------------------------

if nargin==0, prompt=' ? '; end
u=input(prompt,'s'); v=eval(['[',u,']']);
ni=length(v); no=nargout; 
varargout=cell(1,no); k=min(ni,no);
for j=1:k, varargout{j}=v(j); end
if no>ni
	for j=ni+1:no, varargout{j}=nan; end
end   
