% Matlab �Դ�SVM�㷨����svmtrainʵ�֣�������svmclassify�Խ�����SVMģ�ͶԲ������ݽ��з��ࡣ
clc;
clear;
close all;
traindata=[0,1;-1,0;2,2;3,3;-2,-1;-4.5,-4;2,-1;-1,-3]; %������������������
lable=[1,1,-1,-1,1,1,-1,-1]'; %������ǩ
testdata=[5,2;3,1;-4,-3]; %�������ݵ���������
svm_struct=svmtrain(traindata,lable,'Showplot',true);%ѵ��SVMģ��
testlable=svmclassify(svm_struct,testdata,'Showplot',true); %���ݲ���������ģ�ͽ��в���
hold on;
plot(testdata(:,1),testdata(:,2),'ro','MarkerSize',12);
hold off