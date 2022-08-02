for a = 0:0.25:1
  subplot(1,3,1)
  rectangle('Position', [0.5-a/4 0.5-a/4 0.6-a/4 0.4-a/4], ...
	    'Curvature',[1 a], 'Linewidth', 3)
  hold on
  subplot(1,3,2)
  rectangle('Position', [0.5-a/4 0.5-a/4 0.6-a/4 0.4-a/4], ...
	    'Curvature',[1 1], 'Linewidth', 3)
  hold on
  subplot(1,3,3)
  rectangle('Position', [0.5-a/4 0.5-a/4 0.6-a/4 0.4-a/4], ...
	    'Curvature',[a a], 'Linewidth', 3)
  hold on
end; 

