% BLSLAMBDA   Black-Scholes�̒e���l
%
% [LC,LP] = BLSLAMBDA(SO,X,R,T,SIG,Q) �́A�I�v�V�����̒e���l���o�͂��܂��B
% �e���l(����I�v�V�����̃|�W�V�����̃��o���b�W)�́A��b������1%�̕ω�����
% �̃I�v�V�������i�̕ω����̎ړx�ł��BSO �͌��s�����AX �͌����s�g���i�A
% R �͈��S���q�� �AT �̓I�v�V�����̖����܂ł̔N���ASIG �͊����̔N�ԘA��
% �������v���̕W���΍�(�{���e�B���e�B�Ƃ������܂�)�AQ �͔z�����ł��B
% Q �̃f�t�H���g��0�ł��BLC �̓R�[���I�v�V�����̒e���l���Ȃ킿���o���b�W
% �W���ALP �̓v�b�g�I�v�V�����̒e���l�A���Ȃ킿�A���o���b�W�W���ł��B
%        
% ���ӁF 
% ���̊֐��́AStatistics Toolbox�̐��K�ݐϕ��z�֐� normcdf ���g�p���܂��B
%  
% ���Ƃ��΁A[c,p] = blslambda(50,50,.12,.25,.3) �́Ac = 8.1274 �� 
% p = -8.6466 ���o�͂��܂��B
%  
% �Q�l : BLSPRICE, BLSDELTA, BLSGAMMA, BLSRHO, BLSTHETA, BLSVEGA.  
%  
% �Q�l�����F Advanced Options Trading, Daigler, Chapter 4  


%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
