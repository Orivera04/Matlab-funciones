% CFBYZERO   1�g�̃[���Ȑ��Q�ɂ��L���b�V���t���[�̉��i����
%
%   Price = cfbyzero(RateSpec, CFlowAmounts, CFlowDates, Settle)
%
%   Price = cfbyzero(RateSpec, CFlowAmounts, CFlowDates, ...
%                              Settle, Basis)
%
% ����(�K�{): �L���b�V���t���[�����̏ڍׂɂ��ẮA"help instcf" ��
%             �^�C�v���Ă��������B
%
%   RateSpec     - �N�����Z���ꂽ �N�����Z���ꂽ�[�������\���̂ł��B
%
%   ZeroRates    - 10�i�@�Ŏ����ꂽ�[������ NPOINTS �s NCURVES ��̍s��
%                  �ł��B���Ƃ��΁A5%�̓[�����ł� 0.05�ƂȂ�܂��B�[����
%                  �́A0���� EndTime �܂ł̗����ł��B
%
%   CFlowAmounts - �L���b�V���t���[�̊z�ō\�������NINST�sMOSTCFS���
%                  �s��ł��B
%   CFlowDates   - �L���b�V���t���[���t�� NINST �s MOSTCFS ��̍s��ł��B
%   Settle       - ���ϓ��B���̓��t�ɃL���b�V���t���[�̉��i�����肳��
%                  �܂��B
%
% �I�v�V�������́F
%   Basis        - ���t�̃J�E���g��B�f�t�H���g��0�ł��B(actual/actual)
%
% �o��:
%   Price        - ����0�ɂ�������҉��i����Ȃ� NINST �s1��̍s��ł��B
%                  �s��̊e�񂪂��ꂼ��P�̃[���Ȑ��ɑΉ����Ă��܂��B
%
% �Q�l : BONDBYZERO, FIXEDBYZERO, FLOATBYZERO, SWAPBYZERO.


%   Author(s): J. Akao 25-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
