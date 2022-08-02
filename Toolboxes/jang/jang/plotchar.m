function plotchar(vec)
%PLOTCHAR Plots a 35-element vector as a 5x7 grid.

imagesc([zeros(1,7); zeros(7,1) reshape(vec,5,7)' zeros(7,1); zeros(1,7)]);
set(gca,'XTick',[],'YTick',[]);
