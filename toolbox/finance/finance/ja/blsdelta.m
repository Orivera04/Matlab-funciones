% BLSDELTA   �����i�̕ω��ɑ΂���Black-Scholes�̊����x
%
% [CD,PD] = BLSDELTA(SO,X,R,T,SIG,Q)�́A���،����i�̕ω��ɑ΂���I�v�V����
% ���l�̕ϓ������o�͂��܂��B�f���^�́A�w�b�W�䗦�Ƃ��Ă΂�܂��BSO ��
% ���s�����AX �͌����s�g���i�AR �͈��S���q���AT �̓I�v�V�����̖����܂ł�
% �N���ASIG �͔N�����Z���������̘A���������v���̕W���΍�(�{���e�B���e�B
% �Ƃ������܂�)�AQ �͔z�����A���邢�́A�Y������ꍇ�̊O�������ł��B
% Q �̃f�t�H���g�́AQ = 0�ł��BCD �̓R�[���I�v�V�����̃f���^�APD �̓v�b�g
% �I�v�V�����̃f���^�ł��B
%        
% ���ӁF 
% ���̊֐��́AStatistics Toolbox�̐��K�ݐϕ��z�֐� normcdf ���g�p���܂��B
%  
% ���Ƃ��΁A[c,p] = blsdelta(50,50,.1,.25,.3,0) �́Ac = 0.5955 �y�� 
% p = -0.4045 ���o�͂��܂��B
% 
% �Q�l : BLSPRICE, BLSGAMMA, BLSTHETA, BLSRHO, BLSVEGA, BLSLAMBDA.
%  
% �Q�l����: Options, Futures, and Other Derivative Securities, Hull, 
%           Chapter 13. 


%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
