% f9_5
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.5')

clear; clf; hold off
subplot(221)
f = [  1 3 3 5 ];  m = length(f);
s=1:m;
axis([0,6,0,6]); hold on
xlabel('s'); ylabel('f');  plot(s,f,'o')
for k=1:m
  z=int2str(k); sk = s(k); fk=f(k); %text(sk-0.2,fk-0.2,z)
end
t = 0:0.01:1; t2=t.^2; t3=t.^3;
for i=2:m-2
   fb = 1/6*((1-t).^3*f(i-1)+(3*t3-6*t2+ 4)*f(i) + ...
        (-3*t3+3*t2 + 3*t + 1)*f(i+1) + t3*f(i+2) );
   plot(s(i)+t,fb)
end
text(1,6,'Case A')


subplot(222)
f = [  1 3 3 1 ];  m = length(f);
s=1:m;
axis([0,6,0,6]); hold on
xlabel('s'); ylabel('f');  plot(s,f,'o')
for k=1:m
  z=int2str(k); sk = s(k); fk=f(k); %text(sk-0.2,fk-0.2,z)
end
t = 0:0.01:1; t2=t.^2; t3=t.^3;
for i=2:m-2
   fb = 1/6*((1-t).^3*f(i-1)+(3*t3-6*t2+ 4)*f(i) + ...
        (-3*t3+3*t2 + 3*t + 1)*f(i+1) + t3*f(i+2) );
   plot(s(i)+t,fb)
end
text(1,6,'Case B')

subplot(223)
f = [  1 4 4 4 ];  m = length(f);
s=1:m;
axis([0,6,0,6]); hold on
xlabel('s'); ylabel('f');  plot(s,f,'o')
for k=1:m
  z=int2str(k); sk = s(k); fk=f(k); %text(sk-0.2,fk-0.2,z)
end
t = 0:0.01:1; t2=t.^2; t3=t.^3;
for i=2:m-2
   fb = 1/6*((1-t).^3*f(i-1)+(3*t3-6*t2+ 4)*f(i) + ...
        (-3*t3+3*t2 + 3*t + 1)*f(i+1) + t3*f(i+2) );
   plot(s(i)+t,fb)
end
text(1,6,'Case C')

%print fig9d5_zero.ps

subplot(224)
f = [  1 3 3.5  4 ];  m = length(f);
s=1:m;
axis([0,6,0,6]); hold on
xlabel('s'); ylabel('f');  plot(s,f,'o')
for k=1:m
  z=int2str(k); sk = s(k); fk=f(k); %text(sk-0.2,fk-0.2,z)
end
t = 0:0.01:1; t2=t.^2; t3=t.^3;
for i=2:m-2
   fb = 1/6*((1-t).^3*f(i-1)+(3*t3-6*t2+ 4)*f(i) + ...
        (-3*t3+3*t2 + 3*t + 1)*f(i+1) + t3*f(i+2) );
   plot(s(i)+t,fb)
end
text(1,6,'Case D')

% print fig9d5_zero.ps

