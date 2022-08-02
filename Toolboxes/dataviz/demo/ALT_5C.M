%  alt_5c.m

load iris

jit = 0.04;

index = Variety==1;
pl1 = PetalLength(index);
pw1 = PetalWidth(index);
index = Variety==2;
pl2 = PetalLength(index);
pw2 = PetalWidth(index);
index = Variety==3;
pl3 = PetalLength(index);
pw3 = PetalWidth(index);


hg = plot(jitter(pw1,jit),jitter(pl1,jit),'x',...
   jitter(pw2,jit),jitter(pl2,jit),'o',...
   jitter(pw3,jit),jitter(pl3,jit),'+');
xlabel('Width (cm)')
ylabel('Jittered Length (cm)')
title('Iris')
legend(hg,char(VarietyName),4)

