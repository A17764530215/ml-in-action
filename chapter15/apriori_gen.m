function [C]=apriori_gen(A,k)%����Ck��ʵ���������Ӽ���֦ ��   
%A���ֵ�k-1�ε�Ƶ��� k���ֵ�k-Ƶ���
[m n]=size(A);
C=zeros(0,n);
%��������
for i=1:1:m
    for j=i+1:1:m
        flag=1;
        for t=1:1:k-1
            if ~(A(i,t)==A(j,t))
                flag=0;
                break;
            end
        end
        if flag==0 
            break;
        end
        c=A(i,:)|A(j,:);
        flag=isExit(c,A);  %��֦
        if(flag==1)C=[C;c];
        end
    end
end
