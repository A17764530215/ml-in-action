clc
clear
close
load ionosphere; % �������ݣ�ionosphere��UCI�ϵ�һ�����ݼ�������351���۲⣬34���������������ǩ��good & bad
ClassTreeEns = fitensemble(X,Y,'AdaBoostM1',100,'Tree'); % ����AdaBoost�㷨ѵ��100�֣���ѧϰ������Ϊ������������һ��ClassificationEnsemble��
rsLoss = resubLoss(ClassTreeEns,'Mode','Cumulative'); % ������cumulative��ʾ�ۺ�1��T�����������
plot(rsLoss); %����ѵ������������ϵ
xlabel('Number of Learning Cycles');
ylabel('Resubstitution Loss');
Xbar = mean(X); % ����һ���µ�����
[ypredict score] = predict(ClassTreeEns,Xbar) % Ԥ���µ�����������predict����
% ypredict:Ԥ��ı�ǩ score����ǰ����������ÿ����Ŀ��Ŷȣ���ֵԽ�����Ŷ�Խ��
view(ClassTreeEns.Trained{5}, 'Mode', 'graph') ;% ��ʾѵ������������
