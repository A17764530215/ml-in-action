function flag=isExit(c,A)%�ж�c�����Ӵ���A���Ƿ����
[m n]=size(A);
b=c;
for i=1:1:n
    c=b;
    if c(i)==0 continue
    end
    c(i)=0;
    flag=0;
    for j=1:1:m
        A(j,:);
        a=sum(xor(c,A(j,:)));
        if a==0 
            flag=1;
            break;
        end
    end
    if flag==0 return 
    end
end
