% ANNURATE   �N���̒������
%
% R = ANNURATE(NPER,P,PV,FV,DUE)�́A�ݕt�A�܂��́A�N���̎x�������������
% �o�͂��܂��B
% NPER �͊��Ԑ��AP �͒���x���z�APV �͔N���̌��݉��l�AFV �͔N���̏���
% ���l�ADUE �͎x���������Ԃ̏����ɍs����(DUE = 1)���A����(DUE = 0)��
% �s���邩���w�肵�܂��B�f�t�H���g�́AFV = 0 �� DUE = 0 �ł��B
%  
% ���Ƃ��΁A4�N�ԁA��������$130�̎x�������s����$5000�̑ݕt�̒��������
% ���߂܂��B
% 
%       r = annurate(4*12,130,5000,0,0)
%      
% ���̗�ł́A��������Ƃ��āAr = .94% ���o�͂���܂��B�����12�{���邱
% �Ƃɂ��A�ݕt�̔N��11.3% �����߂邱�Ƃ��ł��܂��B
%  
% �Q�l : YLDBOND, ANNUTERM, IRR.


%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
