function Ki=interpk(tk,K,t)
% Interpolates K(:,:,tk) to K(:,:,t);                 6/8/02
%
N=length(tk); j=0;
for i=1:N-1
    if t>=tk(i) & t<tk(i+1); j=i; 
    elseif t==tk(i+1); j=i+1; 
    end
end
Ki=K(:,:,j)+(t-tk(j))*(K(:,:,j+1)-K(:,:,j))/(tk(j+1)-tk(j));