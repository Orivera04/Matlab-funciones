% BLSTHETA   �����܂ł̔N���ɑ΂���Black-Scholes�̊����x
%
% [CT,PT] = BLSTHETA(SO,X,R,T,SIG,Q)�́A���ԂƂ̊֘A�ɂ����ăI�v�V������
% ���l�̊����x���o�͂��܂��BSO �͌��s�����AX �͌����s�g���i�AR �͈��S
% ���q���AT �̓I�v�V�����̖����܂ł̔N���ASIG �͔N�����Z���������̘A��
% �������v���̕W���΍�(�{���e�B���e�B�Ƃ������܂�)�AQ �͔z�����ł��B
% Q �̃f�t�H���g�� 0�ł��BCT �̓R�[���I�v�V�����̃V�[�^�APT �̓v�b�g
% �I�v�V�����̃V�[�^�ł��B
%        
% ���ӁF 
% ���̊֐��́AStatistics Toolbox�̐��K�m�����x�֐� normpdf �Ɛ��K�ݐ�
% ���z�֐� normcdf ���g�p���܂��B
% 
% ���Ƃ��΁A[c,p] = blstheta(50,50,.12,.25,.3,0) �́Ac = -8.9630 �� 
% p = -3.1404 ���o�͂��܂��B
% 
% �Q�l : BLSPRICE, BLSDELTA, BLSGAMMA, BLSRHO, BLSVEGA, BLSLAMBDA.
% 
% �Q�l�����FHull, Options, Futures, and Other Derivative Securities,  
%           2nd Edition, Chapter 13. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
