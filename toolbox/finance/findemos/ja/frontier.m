% FRONTIER   �L���t�����e�B�A
%
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS,TARGET) �́A�|�[�g�t�H���I��
% �L���t�����e�B�A���\������W���΍� Risk ����ю��v�� ROP�A�܂��A�t����
% �e�B�A��̊e�_�ɂ�����e���Y�̉��d WTS ���o�͂��܂��BASSET �́A�e�s��
% �ЂƂ̎��Y���������n��f�[�^��M�sN��̍s��ł��BRET �͎��Y�̎��v����
% ����1�sN��̃x�N�g���ł��BPTS �́A�v�Z�����L���t�����e�B�A��̓_��
% �����w�肵�܂��B�f�t�H���g�ł́APTS = 10 �ł��BTARGET �́AASSET �����
% RET �f�[�^�����Ƃɂ����^�[�Q�b�g�Ƃ�����v����ݒ肵�܂��B�^�[�Q�b�g��
% ���v������͂���ۂɂ́APTS �͋�s��Ƃ��ē��͂��܂��BRISK �� ROR �́A
% PTS�s1��̃x�N�g���ŁAWTS �� PTS�s(���Y��)��̍s��ł��B
% 
% FRONTIER(ASSET,RET) �́AMATLAB ���[�N�X�y�[�X�Ƀf�[�^�𑗂邱�ƂȂ�
% �L���t�����e�B�A���v���b�g���܂��B
%        
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS) �́A�L���t�����e�B�A���
% �W���΍��A���v���A���d���v�Z���܂��B
% 
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,[],TARGET) �́A�t�����e�B�A��̓���
% �̎��v���Ɋ֘A�����L���t�����e�B�A�f�[�^���o�͂��܂��B
% 
% �Q�l : PORTRAND, PORTVAR, PORTROR. 
% 
% �Q�l����: Bodie, Kane, and Marcus, Investments, Chapter 7. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
