% BLSVEGA   �����i�̃{���e�B���e�B�ɑ΂���Black-Scholes�̊����x
%
% V = BLSVEGA(SO,X,R,T,SIG,Q) �́A�����Y�̃{���e�B���e�B�ɑ΂���I�v�V����
% �̉��l�̕ω������o�͂��܂��BSO �͌��s�����AX �͌����s�g���i�AR �͈��S
% ���q���AT �̓I�v�V�����̖����܂ł̔N���ASIG �͔N�����Z���������̘A��
% �������v���̕W���΍�(�{���e�B���e�B�Ƃ������܂�)�AQ �͔z�����ł��B
% Q �̃f�t�H���g��0�ł��B
%
% ���ӁF���̊֐��́AStatistics Toolbox�̐��K�m�����x�֐� normpdf ��
% �g�p���܂��B
% 
% ���Ƃ��΁Av = blsvega(50,50,.12,.15,.3,0) �́Av = 7.5522 ���o�͂��܂��B
%
%
% �Q�l : BLSPRICE, BLSDELTA, BLSGAMMA, BLSTHETA, BLSRHO, BLSLAMBDA. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
