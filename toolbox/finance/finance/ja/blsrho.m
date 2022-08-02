% BLSRHO   �����̕ω��ɑ΂���Black-Scholes�̊����x
%
% [CR,PR] = BLSRHO(SO,X,R,T,SIG,Q)�́A�����ɑ΂���L���،��̉��l�̕ω���
% ���o�͂��܂��BSO �͌��s�L���،����i�AX �͌����s�g���i�AR �͈��S���q���A
% T �̓I�v�V�����̖����܂ł̔N���ASIG �͔N�����Z���������̘A���������v��
% �̕W���΍�(�{���e�B���e�B�Ƃ������܂�)�AQ �͔z�����ł��BQ �̃f�t�H���g
% �� 0�ł��BCR �̓R�[���I�v�V�����̃��[�APR �̓v�b�g�I�v�V�����̃��[�ł��B
%        
% ���ӁF
% ���̊֐��́AStatistics Toolbox�̐��K�ݐϕ��z�֐� normcdf ���g�p���܂��B
% 
% ���Ƃ��΁A[c,p] = blsrho(50,50,.12,.25,.3,0) �́Ac = 6.6686 �� 
% p = -5.4619 ���o�͂��܂��B
% 
% �Q�l : BLSPRICE, BLSDELTA, BLSGAMMA, BLSTHETA, BLSVEGA, BLSLAMBDA. 
% 
% �Q�l���� : Hull, Options, Futures, and Other Derivative Securities, 
%            2nd edition, Chapter 13. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
