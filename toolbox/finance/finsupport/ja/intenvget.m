% INTENVGET   ���q���ԍ\���̑������擾
%
%   ParameterValue = intenvget(RateSpec , 'ParameterName')
%
% ����:
%   RateSpec       - ���q���ԍ\���̑������Ȗ񂵂č쐬���ꂽ�\��
%
%   ParameterName  - �A�N�Z�X�ΏۂƂȂ�p�����[�^��������������ł��B
%                    �����ŁA�w�肳�ꂽ�p�����[�^�̒l���\�� RateSpec 
%                    ��蒊�o����܂��B�p�����[�^�l���ARateSpec �Ŏw��
%                    ����Ă��Ȃ��ꍇ�A��s�񂪏o�͂���܂��B�p�����[�^��
%                    �̐擪�̐��������^�C�v���邾���ŁA�p�����[�^���\��
%                    ���肷�邱�Ƃ��ł��܂��B�Ȃ��A�p�����[�^���ł�
%                    �啶���A�������̋�ʂ͖�������܂��B
%
%  INTENVGET�̃p�����[�^���́A���̒ʂ�ł��B
%     Compounding 
%     Disc
%     Rates 
%     EndTimes
%     StartTimes
%     EndDates
%     StartDates
%     ValuationDate
%     Basis
%     EndMonthRule
%
% �o��:
%   ParameterValue - �\�� RateSpec ���璊�o���ꂽ ParameterName �Ŏw��
%                    ����p�����[�^�̒l�B�p�����[�^�l���ARateSpec �Ŏw��
%                    ����Ă��Ȃ��ꍇ�A��s����o�͂��܂��B
%
% ���:
%   [RateSpec] = intenvset('Rates', 0.08, 'EndTimes', 2)
%   R = intenvget(RateSpec, 'Rates')
%   [R, RateSpec] = intenvget(RateSpec, 'Rates')
%
% �Q�l : INTENVSET.


%   Author(s): M. Reyes-Kattar 02/08/99
%   Copyright 1995-2002 The MathWorks, Inc. 
