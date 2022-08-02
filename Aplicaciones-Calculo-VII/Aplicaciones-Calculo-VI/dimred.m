function [D,R,T]=dimred(X)
% DIMRED - Data Dimension Reduction. Linearly transforms vector data into a
%          subspace of one less dimension. Compresses data along the
%          (arbitrary) direction of smallest spatial extent.
% 
% [D,R,T] = dimred(X)
% 
% X = Original vector data. Each row is a data point. Each column is
%     a dimension in the original space.
% D = Reduced vector data. Each row is a data point. Each column is
%     a dimension in the lower-dimensional space.
% R = "rotation" matrix to convert data from the the reduced space back
%     into the original data space (for example, after performing
%     operations on the data in the lower-dimensional space). Convert D
%     back to X by using X = D*R+T;
% T = "translation" matrix to convert data from the the reduced space back
%     into the original data space (for example, after performing
%     operations on the data in the lower-dimensional space). Convert D
%     back to X by using X = D*R+T;
% 
% NOTES: (1) The narrowest dimension of the data is compressed to zero. No
%            attempt is made to verify that this is prudent. The user may
%            wish to compute a dimensionality ratio r such as
%            g = svd(X); r = min(g) / max(g);
%            or,
%            g = abs(eig(cov(X))); r = min(g)/max(g);
%            and then proceed if r < 1e-6, for example
%        (2) To convert some function F of D back to a function G of X
%            in the higher dimnensional space as follows:
%            X = (original data)
%            [D,R,T] = dimred(X);
%            F = (result of some presumably linear operation perfomed on D)
%            G = F*R+T;
%        (3) ver 1.0, Michael Kleder, July 2005
%
% EXAMPLE:
% % Two-dimensional data in a 3-d space. CONVHULLN will typically
% % return an error in such a case, but by reducing the dimension
% % of the data, a meaningful result is possible.
% C=round(rand(3)*100)/100;
% C=C'*C;
% [V,D]=eig(C);
% D=diag([0 1 2]);
% C=V*D*V';
% mu = [4 4 4];
% X=mvnrnd(mu,C,1000);
% mu=repmat(mu,[size(X,1) 1]);
% % condition inverse of covariance for plots:
% D(1,1)=D(2,2)*1e-6;
% CI=inv(V*D*V');
% d=sum((X-mu)'.*(CI*(X-mu)'));
% X(d>4,:)=[];
% figure
% subplot(2,1,1)
% hold on
% plot3(X(:,1),X(:,2),X(:,3),'b.')
% grid on
% view(45,10)
% axis equal
% axis vis3d
% [D,R,T]=dimred(X);
% k=convhulln(D);
% for n=1:length(k)
%     plot3(X(k(n,:),1),X(k(n,:),2),X(k(n,:),3),'r-','linew',2);
% end
% title('Original Data (3D)')
% subplot(2,1,2)
% plot(D(:,1),D(:,2),'b.')
% grid on
% axis equal
% axis tight
% title('Transformed Data (2D)')

T = repmat(mean(X),[size(X,1),1]);
XX = X-T;
[R,N]=eig(XX'*XX);
D=XX*R;
D=D(:,2:end);
Q=[zeros(size(D,2),1) eye(size(D,2))];
R=Q*R';
return




