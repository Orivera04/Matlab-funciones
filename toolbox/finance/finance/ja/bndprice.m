% BNDPRICE   �����܂ł̗���肩��m�藘�t���̉��i
%
% �^����ꂽSIA���t�p�����[�^�Ɩ����܂ł̔��N���������𔺂� NBONDS  
% ���ɂ��āA�N���[�����i�y�юx������ׂ��o�ߗ��q���o�͂��܂��B
%         
%   [Price, AccruedInt] = bndprice(Yield, CouponRate, Settle, Maturity)
% 
%   [Price, AccruedInt] = bndprice(Yield, CouponRate, Settle, ....
%           Maturity, Period, Basis, EndMonthRule, IssueDate, ....
%           FirstCouponDate, LastCouponDate, StartDate, Face)
%
% ����: [�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANUMBONDS�s1��A�܂��́A1�s
% NUMBONDS��̃x�N�g���A�܂��́A�X�J�������ł��B�I�v�V�����̈����͑S��
% NUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�X�J���A�܂��́A��s��
% �ƂȂ�܂��B����(�I�v�V����)�́A��s��ɂ���ďȗ����邱�Ƃ��ł��܂��B
% ����ɓ���(�I�v�V����)�̒��ŁA�������X�g�̖����Ɉʒu������͂͊�������
% ���Ƃ��ł��܂��B����(�I�v�V����)�̒l���f�t�H���g�l�ɐݒ肷��ɂ́A
% NaN�l����͒l�Ƃ��Đݒ肵�Ă��������B���t�����́A�V���A�����t�ԍ�
% �܂��́A���t������ł��BSIA�m�藘�t���̈����Ɋւ���ڍׂɂ��ẮA
% 'help ftb'�ƃ^�C�v���Ă��������B
% �������̈����Ɋւ���ڍׁA���Ƃ��΁ASettle�́A"help ftbSettle"��
% �^�C�v����ΎQ�Ƃł��܂��B
%
%  Yield (�K�{)      - ���N�����v�Z�̖��������
%  CouponRate (�K�{) - 10�i�@�ŕ\�L���ꂽ�N�[�|������
%  Settle (�K�{)     - ���ϓ�
%  Maturity (�K�{)   - ������
%
% ����(�I�v�V����):
%  Period            - 1�N�ł̃N�[�|���x����(�f�t�H���g��2)
%  Basis             - �����J�E���g��B�f�t�H���g��0 (actual/actual)
%  EndMonthRule      - �����K���B�f�t�H���g��1(�����K���͗L��)
%  IssueDate         - ���̔��s��
%  FirstCouponDate   - �s����A�܂��́A�ʏ�̑�1��N�[�|���x����
%  LastCouponDate    - �s����A�܂��́A�ʏ�̍ŏI�N�[�|���x����
%  StartDate         - �x������O�����ăX�^�[�g��������t
%                      (2.0�ł͂��̈����̓��͖͂�������܂��B)
%  Face              - ���̊z�ʉ��l�B�f�t�H���g��100
%
% �o��: NBONDS�s1��̃x�N�g��
%  Price      : ���̃N���[�����i
%  AccruedInt : ���ώ��Ɏx������o�ߗ��q
%
% ����:
%  ���̃_�[�e�B���i�́A�N���[�����i�Ɍo�ߗ��q�𑫂����킹�邱�Ƃɂ����
%  �Z�o�ł��܂��B�Ȃ��A���̃_�[�e�B���i�́A���L���b�V���t���[�̌���
%  ���l�Ɠ����ł��B
%    
%  ���i�Ɨ������֘A�t���Ă���̂́A���̌����ł��B
%
%    ���i + �o�ߗ��q = sum ( �L���b�V���t���[*(1+�����/2)^(-����))
%
%  �����ŁAsum(���a)�́A���̃L���b�V���t���[�y�є��N�����N�[�|�����Ԃ�
%  �P�ʂɂ��đ��肳���L���b�V���t���[�ɑΉ����鎞�Ԃɂ킽���Čv�Z����
%  �܂��B
%
% �Q�l : BNDYIELD, CFAMOUNTS.


%  Author(s): J. Akao 05/01/98
%   Copyright 1995-2002 The MathWorks, Inc. 
