% DEPGENDB   ��ʒ����c���������p(�藦�������p�@)
%
% D = DEPGENDB(COST,SALVAGE,LIFE,FACTOR) �́A�e���Ԃ̈�ʒ����c������
% ���p�� D ���v�Z���܂��BCOST �͎��Y�̌����ASALVAGE �͎��Y�̌��Ϗ���
% ���i�ł��BLIFE �͎��Y���������p������Ԑ��AFACTOR �͌������p�W���ł��B
% FACTOR = 2 �Ƃ���ƁA��d�����c���������p�@���g�p���邱�Ƃ��Ӗ����܂��B
% 
% ���F
% 1��̏�p�Ԃ�$11,000�ōw�����A5�N�ԂŌ������p���܂��B���̌��Ϗ������i
% ��$1000�ł��B���̊֐��́A��d�����c���������p�@��p���āA�e�N�̌�����
% �p����v�Z���A���̏�p�Ԃ̑ϗp�N���̏I���̎c���������p�\���l���o��
% ���܂��B
% 
%       d = depgendb(11000,1000,5,2)�@
% 
% ���̌��ʁA
% 
%       d = [4400.00,2640.00,1584.00,950.40,425.60] ���o�͂���܂��B
% 
% �Q�l : DEPFIXDB, DEPRDV, DEPSOYD, DEPSTLN.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
