%����AlreadyThereRow,�ж�������ΪCol�������Ǵ���ָ���ĺڵ����� 
%����������ص���WhichRow�е�ֵǡ��ΪcurrentRow 
%���������������أ�����ֵthereIsOneΪ1������Ϊ0 
function [thereIsOne] = AlreadyThereRow(pointbak,Col,currentRow,WhichRow) 
%����ֵ��Ĭ��ΪӦ��Ϊ0 
thereIsOne = 0; 
%���ColС�ڵ���0���߳����Ͻ磬ֱ�ӷ���0 
if Col <= 0 || Col > 128 
    thereIsOne = 0; 
else 
    %ѭ�����м�� 
    for i = 1:1:128 
        if pointbak(i,Col) == 1 
            if WhichRow(i,Col) == currentRow 
               thereIsOne = 1; 
            end 
        end 
    end 
end 