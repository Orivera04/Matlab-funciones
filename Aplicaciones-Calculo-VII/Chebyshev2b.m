% Function: f(x) = sign(x)
% using polyfit at chebyshev points

n = 8; %initialize n to 8 and loop to 32
count = 1;
while n<=32,    
    resolution = 100; %graphing resolution for X
    for i=0:n
        X(1,i+1) = -1 * cos(((pi/(n+1))*(0.5+i))); %compute chebyshev points
    end
    clear i;
    for i=0:n
        Y(1,i+1) = sign(X(1,i+1)); %find actual points using sign(x) eq.
    end
    [P,S] = polyfit(X,Y,n); %perform actual fit
    clear i
    for step=0:2*resolution
        clear Q;
        for i=n:-1:0
            temp = 1;
            for j=0:i-1
                temp = temp * (step/resolution-1); %performing looping X^n
            end
            Q(1,n-i+1) = P(1,n-i+1) * temp;
        end
        total = 0;
        for i=0:n
            total = total + Q(1,i+1);
        end
        Xapp(1,step+1) = step/resolution - 1;
        Yapp(1,step+1) = total; %assign polynomial value on Y @ X step
    end
    subplot(3,1,count), plot(X,Y);
    hold on;
    subplot(3,1,count), plot(Xapp,Yapp,'color',[.6 0 0]);
    n = n * 2;
    count = count + 1;
    clear Xapp Yapp Q X Y step i j
end

