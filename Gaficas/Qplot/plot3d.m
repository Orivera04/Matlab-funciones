function plot3d (type)
global A opt holdon label

if isempty(A) errordlg ('No data present. Sure you read a file yet?','Error'); return; end
if size(A,2) < 3 errordlg (['Seems to be only ',num2str(size(A,2)),' columns of data. Need at least 3'],'Error'); return; end

figure (2);
if (holdon)	hold on; else 	hold off; end

X= A(:,opt.xc(1));
Y= A(:,opt.yc(1));
M= A(:,opt.zc);
if size(M,2) > 1 & size(M,2) < length(X)
	warn= msgbox('Number of Z columns > 1 but < number of rows in X. Only the 1st Z column displayed','Warning');
	waitfor(warn);
	M= A(:,opt.zc(1));
end

if size(M,2) == 1
   [XI,YI]= meshgrid(min(X):range(X)/(length(X)-1):max(X),min(Y):range(Y)/(length(Y)-1):max(Y));
	Mitp= griddata(X,Y,M,XI,YI);
end

switch type
	case 'waterfall'
		if size(M,2) ~= 1 waterfall(X,Y,M); end
		if size(M,2) == 1 waterfall(XI,YI,Mitp);
		end
	case 'ribbon'
		ribbon(X,M);
	case 'grid'
		if size(M,2) ~= 1 mesh(X,Y,M); end
		if size(M,2) == 1 mesh(XI,YI,Mitp); 
		end
	case 'bar3'
		bar3(X,M,'detached');
	case 'plot3'
		plot3(X,Y,M,'o');
	case 'stem3'
		stem3(X,Y,M(:,1));
	case 'surface'
		if size(M,2) ~= 1 surf(X,Y,M); end
		if size(M,2) == 1 surf(XI,YI,Mitp); 
		end
	case 'smooth'
		if size(M,2) ~= 1 surfl(X,Y,M); end
		if size(M,2) == 1 surfl(XI,YI,Mitp); 
		end
		shading interp;
		colormap(pink);
	case 'contour'
		if size(M,2) ~= 1 contour(X,Y,M,10); end
		if size(M,2) == 1 contour(XI,YI,Mitp,10); end

end
title(label.t); xlabel(label.x); ylabel(label.y); zlabel(label.z);
grid on;
return
