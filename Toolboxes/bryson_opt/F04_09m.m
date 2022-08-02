% Script f04_09m.m; movie of min time-to-climb to 20 km, M=1, ga=0 for
% F4 A/C; starts from V=929 ft/sec and W=Wo*.9888 (where climb begins);
%                                                         12/94, 4/5/02
%
Ns=200; load f04_09
%
figure(1); clf; for i=1:Ns+1,
   plot(x2(i),h2(i),'bo',[0 400],65.6*[1 1],'r--',[0 400],[0 0],...
   'r--',x2,h2,'g--'); axis([0 x2(Ns+1) -100 125]); axis off 
   pause(.1); end; hold off; pause(2)
% 
figure(2); clf; plot(x2,h2,'g',[0 400],65.6*[1 1],'r--',...
   [0 400],[0 0],'r--'); hold on; for i=1:5:Ns+1,
   plot(x2(i),h2(i),'b.'); axis([0 x2(Ns+1) -100 125]); axis off
end; hold off

