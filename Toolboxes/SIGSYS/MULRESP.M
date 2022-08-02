function [iu,nargs,y,y2]=mulresp(fun,a,b,c,d,t,nargo,bodeflag);
%MULRESP Multivariable response.
%
%	[IU,NARGS,Y,Y2] = MULRESP('fun',A,B,C,D,T,NARGO,BODEFLAG)

%	Andrew Grace  7-9-90
%	Revised ACWG 6-21-92
%	Copyright (c) 1986-93 by the MathWorks, Inc.

[r,m]=size(d);
if r*m>1 	% MIMO system
	iu=0;
	if nargo==0
		clg
		hold off
		if r*m==2, sp=210; else sp=220; end
		scnt=0;
		for i=1:m
		    if bodeflag==0,
		        for j=1:r
		            if scnt==4, drawnow, figure, scnt=0; end
		            scnt=scnt+1; subplot(sp+scnt)
		            if ~isempty(c), cj = c(j,:); end
		            if ~isempty(d), dj = d(j,:); end
		            eval([fun,'(a,b,cj,dj,i,t);']);
		            title(['Input ', int2str(i),' Output ',int2str(j)])
		        end
		    else 
		        if scnt==4, drawnow, figure, scnt=0; end
		        scnt = scnt+4;
		        eval([fun,'(a,b,c,d,i,t);']);
				subplot(211)
				if (m > 1)
		        	title(['Input ', int2str(i)])
				end
		    end
		end
		subplot(111)
	else
		y=[]; y2=[];
		for i=1:m
		    if bodeflag==0
		        eval(['y=[y,',fun,'(a,b,c,d,i,t)];'])
		    else
% Force compile to recognize these variables: 
		        phase =[];  mag = [];
		        eval(['[mag,phase]=',fun,'(a,b,c,d,i,t);'])
		        y=[y,mag]; 
		        y2=[y2,phase];
		    end

		end
	end
else		% SISO systems
	iu=1; nargs=5;
end

