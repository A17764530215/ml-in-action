function [L]=apriori(D,min_sup)
[L,A]=init(D,min_sup); %AΪ1-Ƶ�  L��Ϊ����1-Ƶ����Լ���Ӧ��֧�ֶ�
k=1;
C=apriori_gen(A,k); %����2-��Ϻ�ѡ�� 
while (size(C,1)~=0) %C�������Ϊ0�������ѭ��
    [M,C]=get_k_itemset(D,C,min_sup);%����k-Ƶ��� M�Ǵ�֧�ֶ�  C����֧�ֶ�
    if size(M,1)~=0
        L=[L;M];   
    end
    k=k+1;
    C=apriori_gen(C,k);%������Ϻ�ѡ�� 
end
