% CPNDATEP   �m�藘�t�ɑ΂���O��̎��ۂ̃N�[�|����
%
% ���̊֐��́ANUMBONDS �������݂���m�藘�t�̃Z�b�g�ɂ��āA�O���
% �N�[�|�������o�͂��܂��B���̊֐��́A���Y�،��̑�1��܂��͍ŏI�N�[�|��
% ���Ԃ�����̒����ł���̂��A�܂��͂�������������Ԃ܂��͒Z�����Ԃł�
% ��̂��Ɋւ�炸�A���Y�،��ɂ��đO��̃N�[�|�������o�͂��܂��B�[��
% �N�[�|���ɂ��ẮA���̊֐��͖��������o�͂��܂��B
%
%   PreviousCouponDate = cpndaten(Settle, Maturity)
%
%   PreviousCouponDate = cpndatep(Settle, Maturity, Period, Basis, 
%                             EndMonthRule, IssueDate, FirstCouponDate,
%                             LastCouponDate)
% ����:
%  Settle    - ���ϓ�
%  Maturity  - ������
%
% ����(�I�v�V����)�F
%  Period          - 1�N�ł̃N�[�|���x����; �f�t�H���g��2(���N����)
%  Basis           - �����̃J�E���g�; �f�t�H���g�� 0 (actual/actual)
%  EndMonthRule    - �����K��; �f�t�H���g��1(�����K���͗L��)
%  IssueDate       - �،��̔��s��
%  FirstCouponDate - �s����܂��͒ʏ�̑�1��N�[�|���x����
%  LastCouponDate  - �s����܂��͒ʏ�̍ŏI�N�[�|���x���� 
%
% �o��: 
% PreviousCouponDate - ���ϓ��y�т���ȑO�ɓ����������ۂ̑O��N�[�|����
%   ����Ȃ� NUMBONDS�s1��̃x�N�g���ł��B���ϓ����N�[�|�����Ɠ����
%   �ꍇ�A���̊֐��͌��ϓ����o�͂��܂��B���Ȃ킿�����Ɍ��ϓ��܂��͂���
%   �ȑO�̎��ۂ̃N�[�|���������̊֐��͏o�͂��܂����A�O��N�[�|������
%   ���s���ȑO�ƂȂ�ꍇ��(���ꂪ�A���Ƃ����p�\�ł������Ƃ��Ă�)
%   ���O���܂��B���̂��߁A���̊֐��͎��ۂ̔��s���܂��͌��ϓ������
%   �����O��N�[�|�����̂����ꂩ�߂��ق��̓��t���o�͂��܂��B
%
% ���ӁF[�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANUMBONDS�s1��A�܂��́A1�s
%   NUMBONDS��̃x�N�g���܂��̓X�J�������łȂ���΂Ȃ�܂���B�I�v�V����
%   �ƂȂ�S�Ă̈����́ANUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A
%   �X�J���܂��͋�s��łȂ���΂Ȃ�܂���B�l�̎w��̂Ȃ����͂ɂ� NaN ��
%   ���̓x�N�g���Ƃ��Đݒ肵�Ă��������B���t�́A�V���A�����t�ԍ��܂���
%   ���t������ł��B
%
%   ���ꂼ��̓��͈����y�яo�͈����̏ڍׂɂ��ẮA�R�}���h���C�����
%   'help ftb' + ������(���Ƃ��΁ASettle(���ϓ�)�Ɋւ���w���v�́A
%   "help ftbSettle")�ƃ^�C�v���ē����܂��B 
%
% �Q�l : CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.


%Copyright 1995-2002 The MathWorks, Inc.
