% FVFIX   ��z����x�����̏������l
%
% F = FVFIX(RATE,NPER,P,PV,DUE) �́A��A�̋ϓ��x�����̏������l���o�͂�
% �܂��BRATE �͒�������ANPER �͊��Ԑ��AP �͒���x���z�APV �͓������l�ŁA
% DUE �͎x���������Ԃ̏����ɍs����(DUE = 1)���A����(DUE = 2)�ɍs����
% �����w�肵�܂��B�f�t�H���g�ł́ADUE = 0 �� PV = 0�ł��B 
% 
% ���F
% ��s������$1500�̓����c��������Ƃ��܂��B10�N�ԁA��������$200������
% ����A�����ɂ�9%�����Ŗ����̗��q�������܂��B���̃f�[�^���g�p�����
% 
%         f = fvfix(.09/12,12*10,200,1500,0)
% 
% �́Af = 42379.89 ���o�͂��܂��B
% 
% �Q�l : PVFIX, PVVAR, FVVAR.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  