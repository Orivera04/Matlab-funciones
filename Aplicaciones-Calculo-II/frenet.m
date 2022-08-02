function [t,Tg,Nm,Bn, x] = frenet(curvature,torsion, T0,N0, tspan, handles)
[cur, tor] = inputmgt(curvature, torsion);
h = @(t) [cur(t), tor(t)];
F = @(t) diag(h(t),1) - diag(h(t),-1);
A = @(t) kron(F(t), eye(3));

%T0 = [1 0 0];
%N0 = [0 1 0];
B0 = cross(T0,N0);
w0 = [T0,N0,B0];

[t,w] = ode45(@(t,w) A(t)*w, [0 tspan], w0);

Tg = w(:,1:3);
Nm = w(:,4:6);
Bn = w(:,7:9);

x = 0.5* cumsum(repmat(diff(t),1,3) .* (Tg(2:end,:) + Tg(1:end-1,:)));

%visualizefrenet(x,Tg,Nm,Bn,t, factor)
plot3(x(:,1),x(:,2), x(:,3), 'parent', handles.axes1)
grid on
axis tight
axis off

function  [hx,hy] = inputmgt(x,y)
eval(['hx = @(t) ' x ';']);
eval(['hy = @(t) ' y ';']);

% function visualizefrenet(x,Tg,Nm,Bn,t, factor)
% plot3(x(:,1),x(:,2), x(:,3))
% hold on
% axis tight
% 
% 
% y1 = x+ factor* Tg(1:end-1,:);
% y2 = x+ factor* Nm(1:end-1,:);
% y3 = x+ factor* Bn(1:end-1,:);
% for j = 1:length(y1)
%         hp(1) = plot3([x(j,1) y1(j,1)], ...
%               [x(j,2) y1(j,2)],...
%               [x(j,3) y1(j,3)], 'g:');
%         hp(2) = plot3([x(j,1) y2(j,1)], ...
%               [x(j,2) y2(j,2)],...
%               [x(j,3) y2(j,3)], 'r:');    
%         hp(3) = plot3([x(j,1) y3(j,1)], ...
%               [x(j,2) y3(j,2)],...
%               [x(j,3) y3(j,3)],'y:');
%           
%               pause(t(j+1)-t(j))
%               delete(hp)
% end
