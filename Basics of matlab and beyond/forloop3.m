N = 200;s = triu((1:N)'*ones(1,N));a = zeros(N,N);for i=1:N-1  a(i,:) = sum(s(i:end,:));enda(N,:) = s(N,:);
