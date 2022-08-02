% BLSPRICE   Black-Scholes�̃v�b�g���i�y�уR�[�����i�̌���
%
% [CALL,PUT] = BLSPRICE(SO,X,R,T,SIG,Q) �́ABlack-Scholes �̉��i���莮��
% �g�p���āA�R�[���I�v�V�����ƃv�b�g�I�v�V�����̉��l���o�͂��܂��BSO ��
% ���s���Y���i�AX �͌����s�g���i�AR �͈��S���q���AT �̓I�v�V������
% �����܂ł̔N���ASIG �͔N�����Z���������̘A���������v���̕W���΍�(�{��
% �e�B���e�B�Ƃ������܂�)�AQ �͎��Y�̔z�����ł��BQ �̃f�t�H���g��0�ł��B
%        
% ���ӁF 
% R �� T ���������ԂɊ�Â��Ă��邱�Ƃ��m���߂Ă��������B���Ȃ킿�A
% R ���N���̏ꍇ�AT �͔N�\���łȂ���΂Ȃ�܂���B
%
% ���̊֐��́AStatistics Toolbox�̐��K�ݐϕ��z�֐� normcdf ���g�p���܂��B
% 
% ���F
% ���鎑�Y�̌��s���i��$100�A�����s�g���i��$95�A���S���q����10%�A�I
% �v�V�����̖����܂ł̔N����0.25�N�A���Y�̕W���΍���50%�Ƃ��܂��B
% 
%       call = blsprice(100,95,.1,.25,.5,0)
% 
% ���̌��ʁA�R�[���I�v�V�������i��$13.70�Əo�͂���܂��B
%        
% �Q�l���� : Bodie, Kane, and Marcus, Investments, page 681. 
% 
% �Q�l : BLSIMPV, BLSDELTA, BLSGAMMA, BLSLAMBDA, BLSTHETA, BLSRHO. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
