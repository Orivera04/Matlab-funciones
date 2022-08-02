Z = peaks; surf(Z); 
axis tight
set(gca,'nextplot','replacechildren');
% Record the movie
for j = 1:20 
    surf(sin(2*pi*j/20)*Z,Z)
    F(j) = getframe;
end
% Play the movie twenty times
movie(F,20)