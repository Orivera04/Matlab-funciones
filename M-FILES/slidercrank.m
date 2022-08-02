n = 40; phi = linspace(0, 2*pi, n);
a = 1; b = 2.5; e = 0.25; nF = 5;
c = 0.5; d = 1; f = 0.06;
ax = a*cos(phi); ay = a*sin(phi);
s = real(ax+sqrt(b^2-(ay-e).^2));
v = [1.1*min(ax), 1.1*(max(s)+d/2) 1.1*min(ay), 1.1*max(ay)];
xgnd = [min(ax), max(s)+d/2, max(s)+d/2, min(ax), min(ax)];
ygnd = [e, e, e-f, e-f, e];
slidery = [e, e+c, e+c, e, e]; % Vertical component of slider is constant
for k = 1:n
fill(xgnd, ygnd, 'r') % Thin horizontal bar
hold on
plot(ax, ay, 'b--', 0, 0, 'ko'); % Dashed circle and center of circle
sliderx = [s(k)-d/2, s(k)-d/2, s(k)+d/2, s(k)+d/2, s(k)-d/2];
fill(sliderx, slidery, 'm'); % Slider position
plot([0 ax(k)], [0;ay(k)], 'ko-', 'LineWidth', 2);
plot([ax(k), s(k)], [ay(k), e+c/2], 'ko-', 'LineWidth', 2);
axis(v)
axis off equal
SliderCrankFrame(k) = getframe;
hold off
end
movie(SliderCrankFrame, nF, 30)
movie2avi(SliderCrankFrame, 'SliderCrankAvi.avi', 'compression', 'none')