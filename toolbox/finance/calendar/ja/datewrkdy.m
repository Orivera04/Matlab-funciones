% DATEWRKDY   �����A�܂��́A�ߋ��̉c�Ɠ�
%
%     EndDate = datewrkdy(StartDate, NumberWorkDays, NumberHolidays) 
%
% �ڍׁF���̊֐��́A�c�Ɠ��y�ыx���Ɋւ��āA�ݒ肵���������������A
%   �܂��́A�ߋ��ɓ��t���ړ����āA�����A�܂��́A�ߋ��̓��̓��t���o��
%   ���܂��B
%
% ����: 
% StartDate       - �ŏ��̓��t���V���A�����t�ԍ��A�܂��́A���t������Ŏ���
%                   �l�ō\�������N�s1��A�܂��́A1�sN��̃x�N�g���ł��B
% NumberWorkDays  - ����(���̏ꍇ)�A�܂��́A�ߋ�(���̏ꍇ)�ɂǂꂾ����
%                   �c�Ɠ����������t�𓮂��������w�肷��l�ō\�������
%                   N�s1��A�܂��́A1�sN��̃x�N�g���ł��B
% NumberHolidays  - ����(���̏ꍇ)�A�܂��́A�ߋ�(���̏ꍇ)�ɂǂꂾ����
%                   �x�����������t�𓮂��������w�肷��l�ō\�������N�s
%                   1��A�܂��́A1�sN��̃x�N�g���ł��B
% 
% �o��: 
% EndDate         - ���ʂƂ��ċ��܂鏫���A�܂��́A�ߋ��̓��t�̓��t�ԍ���
%                   ����N�s1��A�܂��́A1�sN��̃x�N�g���ł��B
%
% ���: 
%              StartDate = '20-Dec-1994';
%              NumberWorkDays = 16;
%              NumberHolidays = 2;
%
%              datewrkdy(StartDate, NumberWorkDays, NumberHolidays)
%
%              ���̌��ʁA���̒l���o�͂���܂��B  
%
%              EndDate = 728671 (12-Jan-1995)
% 
% �Q�l : WRKDYDIF. 


%Author(s): C.F. Garvin, 2-23-95; C. Bassignani, 10-26-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
