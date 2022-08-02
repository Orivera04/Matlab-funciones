%% T Puzzle Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the T Puzzle Chapter of "Experiments in MATLAB".
% You can access it with
%
%    puzzle_recap
%    edit puzzle_recap
%    publish puzzle_recap
%
% Related EXM programs
%
%    t_puzzle

%% The T Puzzle
    close all
    figure
    t_puzzle

%% Polar Form of a Complex Number.
    z = 3 + 4i
    r = abs(z)
    phi = angle(z)
    z_again = r*exp(i*phi)

%% A Puzzle Piece.
    figure
    z = [0 1 1+2i 3i 0]
    line(real(z),imag(z),'color','red')
    axis([-2.5 1.5 -.5 4.0])

%% Translation.
    z = z - (3-i)/2
    line(real(z),imag(z),'color','blue')

%% Rotation.
    mu = mean(z(1:end-1));
    theta = pi/10;
    omega = exp(i*theta);
    z = omega*(z - mu) + mu
    line(real(z),imag(z),'color','green')
