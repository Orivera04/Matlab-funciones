function n_trozos(a,b,n)
for i=1:n
    disp(['subintervalo #',num2str(i)]);
    x=input('int= ');
    disp(['función #',num2str(i)]);
    y=input('fun= ');
    plot(x,y);
    grid on;
    hold on;
    %axis([0 4 0 7]);
    inix(i)=x(1);
    iniy(i)=y(1);
    finx(i)=x(end);
    finy(i)=y(end);
end
for k=1:n-1
    x1=[finx(k),finx(k)];y1=[finy(k),iniy(k+1)];
    plot(x1,y1,'--r');
end
hold off