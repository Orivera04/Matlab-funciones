% CPNDATEN   �m�藘�t�ɑ΂��鎟��̎��ۂ̃N�[�|���x����
%
% ���̊֐��́ANUMBONDS�̊m�藘�t���̃Z�b�g�ɂ��āA����̎��ۂ�
% �N�[�|�����o�͂��܂��B���̊֐��́A���Y���̑�1��܂��͍ŏI�N�[�|��
% ���Ԃ�����̒����ł��邩�A�܂��͂�������������Ԃ܂��͒Z�����Ԃ�
% ���邩�Ɋւ�炸�A���Y���ɂ��Ď���̎��ۂ̃N�[�|�������o�͂��܂��B
% �[���N�[�|���̏ꍇ�A���̊֐��͖��������o�͂��܂��B
%
%   NextCouponDate = cpndaten(Settle, Maturity)
%
%   NextCouponDate = cpndaten(Settle, Maturity, Period, Basis, ....
%               EndMonthRule, IssueDate, FirstCouponDate,...
%               LastCouponDate)
% ����:  
%   Settle    - ���ϓ�
%   Maturity  - ������
%
% ����(�I�v�V����)�F
%   Period          - 1�N�ł̃N�[�|���x����; �f�t�H���g��2(���N����)
%   Basis           - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%   EndMonthRule    - �����K��; �f�t�H���g��1(�����K���͗L��)
%   IssueDate       - ���̔��s��
%   FirstCouponDate - �s����܂��͒ʏ�̑�1��N�[�|���x����
%   LastCouponDate  - �s����܂��͒ʏ�̍ŏI�N�[�|���x���� 
%
% �o��: 
%   NextCouponDate - ���ϓ��ȍ~�̎��ۂ̎���N�[�|�����̓��t����Ȃ�
%                    NUMBONDS�s1��̃x�N�g���ł��B���ϓ����N�[�|������
%                    ����̏ꍇ�A���̊֐��͌��ϓ����o�͂��܂���B
%                    ���̑���ɁA�����Ɍ��ϓ��ȍ~�̎��ۂ̃N�[�|������
%                    �o�͂��܂�(�������A�������ȍ~�̏ꍇ������)�B
%                    ���̂��߁A���̊֐��͏�Ɏ��ۂ̖������Ǝ���N�[�|��
%                    �x�����̂����A���߂��ق��̓��t����ɏo�͂��܂��B
%
% ���ӁF[�K�{]�Ǝw�肳��Ă���S�Ă̈����́A NUMBONDS�s1��A�܂��́A1�s
%   NUMBONDS��̃x�N�g���܂��̓X�J�������łȂ���΂Ȃ�܂���B�I�v�V����
%   �ƂȂ�S�Ă̈����́ANUMBONDS �s1��A�܂��́A1�s NUMBONDS ��̃x�N
%   �g���A�X�J���܂��͋�s��łȂ���΂Ȃ�܂���B�l�̎w��̂Ȃ����͂ɂ� 
%   NaN ����̓x�N�g���Ƃ��Đݒ肵�Ă��������B���t�́A�V���A�����t�ԍ�
%   �܂��͓��t������ł��B
%
%   ���ꂼ��̓��͈����y�яo�͈����̏ڍׂɂ��ẮA�R�}���h���C�����
%   'help ftb' + ������(���Ƃ��΁ASettle(���ϓ�)�Ɋւ���w���v�́A
%   "help ftbSettle"�j�ƃ^�C�v���ĎQ�Ƃł��܂��B 
%
% �Q�l : CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.


% Copyright 1995-2002 The MathWorks, Inc. 
