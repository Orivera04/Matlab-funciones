% WRKDYDIF   ���t�Ԃ̉c�Ɠ��̐�
%
%  NumberDays = WRKDYDIF(Date1, Date2, NumberHolidays) 
%
% �ڍ�: ���̊֐��́A�x�Ɠ������ݒ肳���ƁA2�̓��t�Ԃ̉c�Ɠ�����
%       �o�͂��܂��B
% 
% ����: 
%  Date1          - �J�n�����������t������A�܂��́A�V���A�����t�ԍ���
%                   �\������� N�s1��A�܂��́A1�sN��̃x�N�g���ł��B
%  
%  Date2          - �ŏI�����������t������A�܂��́A�V���A�����t�ԍ���
%                   �\�������N�s1��A�܂��́A1�sN��̃x�N�g���ł��B
%  
%  NumberHolidays - ���̋x���܂ł̏���(��)�܂��͉ߋ�(��)�ւ̈ړ�����������
%                   �l�ō\�������N�s1��A�܂��́A1�sN��̃x�N�g���ł��B 
%
%  �o��: 
%  NumberDays      - Date1 �y�� Date2 �̊Ԃ̓���������N�s1��A�܂��́A
%                    1�sN��̃x�N�g���ł��B
%
%  ���: 
%  Date1 = '9/1/1995';
%  Date2 = '9/11/1995';
%  NumberHolidays = 1;
%
%  NumberDays = wrkdydif(Date1, Date2, NumberHolidays)
%
%  ���̌��ʁA���̒l���o�͂���܂��B
%
%   NumberDays = 6
% 
% �Q�l : DATEWRKDY.


%Author(s): C.F. Garvin, 2-23-95, C. Bassignani, 10-7-97
%       Copyright 1995-2002 The MathWorks, Inc. 
