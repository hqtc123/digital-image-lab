%ͨ�õĶ�ֵ��̬ѧ���㣨��ʴ�����͡������պͻ��л����б任������ 
%************************************************************************** 
function resultImg=morphologic(img,operator) 
%***********************************��ʼ������****************************** 
[x,y]=size(img);%���ԭͼ��Ĵ�С 
%��ʼ�������м���� 
img1=false(x,y); 
img2=false(x,y); 
img3=false(x,y); 
output=false(x,y); 
%********************�����û�ѡ��Ĳ������ж�ֵ��̬ѧ����********************* 
switch operator 
%*********************************��ʴ����********************************** 
    case 'erosion' 
        se = [1 1 1;1 1 1;1 1 1];%����ṹ��Ԫ��3*3���Σ� 
        resultImg = erosion(img,se);%���ø�ʴ���㺯�����и�ʴ���� 
      
 
%*********************************��������********************************** 
    case 'dilation' 
        se =[1 1 1;1 1 1;1 1 1];%����ṹ��Ԫ��3*3���Σ� 
        resultImg=dilation(img,se);%�����������㺯�������������� 
     
%*********************************�ṹ���任******************************** 
    case 'open' 
        se =[1 1 1;1 1 1;1 1 1];%����ṹ��Ԫ��3*3���Σ� 
        %�ṹ���任���ȸ�ʴȻ�������� 
        img1=erosion(img,se); 
        resultImg=dilation(img1,se); 
%*********************************�ṹ�ձ任******************************** 
    case 'close' 
        se =[1 1 1;1 1 1;1 1 1];%����ṹ��Ԫ��3*3���Σ� 
        %�ṹ���任��������Ȼ���ٸ�ʴ 
        img1=dilation(img,se); 
        resultImg=erosion(img1,se); 
%*********************************���л����б任**************************** 
    case 'hit_miss' 
        se1 = [0 0 0;0 1 1;1 1 1];%����ṹ��Ԫ 
        se2 = [0 0 0;0 0 0];%����ṹ��Ԫ 
        %img1=erosion(img,se1); 
        %img2=erosion(~img,se2); 
        %img3=img1&img2; 
        resultImg=erosion(img,se1) & ~dilation(img,se2); 
end 
 
 
 
%*******************************��ʴ���㺯��******************************** 
function imageErode = erosion(image,se) 
 
[RowNum,ColNum] = size(image);%ȡͼ��Ŀ�Ⱥ͸߶� 
[rowB,colB] = size(se);%ȡ�ṹ��Ԫ�ĳ��ȺͿ�� 
imageErode = false(RowNum,ColNum);%��ʼ������ͼ�� 
%������ṹ��Ԫ������λ�� 
centerRow = floor((rowB+1)/2); 
centerCol = floor((colB+1)/2); 
 
for i = 1:1:RowNum 
    for j = 1:1:ColNum 
        if image(i,j) == 1 
            Erode = 0;%DoErode��ʾҪ��Ҫ�Ըõ���и�ʴ����ʼ����Ϊ����ʴ 
            for p = 1:1:rowB 
                for q = 1:1:colB 
                    destRow = i+p-centerRow; 
                    destCol = j+q-centerCol; 
                    if (destRow >= 1 && destRow <= RowNum && destCol >= 1 && destCol <= ColNum)%�ж������±��Ƿ�Խ�� 
                         if se(p,q) ~= image(destRow,destCol) 
                             Erode = se(p,q); 
                         end 
                     end 
                end 
            end 
            if Erode == 0 
                imageErode(i,j) = se(p,q); 
            end 
        end 
    end 
end 
 
%************************************************************************** 
%*******************************�������㺯��******************************** 
function imageDilate = dilation(image,se) 
 
[RowNum,ColNum] = size(image);%ȡͼ��Ŀ�Ⱥ͸߶� 
[rowB,colB] = size(se);%ȡ�ṹ��Ԫ�Ŀ�Ⱥ͸߶� 
imageDilate = false(RowNum,ColNum);%��ʼ������ͼ�� 
%������ṹ��Ԫ������λ�� 
centerRow = floor((rowB+1)/2); 
centerCol = floor((colB+1)/2); 
 
for i = 1:1:RowNum 
    for j = 1:1:ColNum 
        if image(i,j) == 1 
            for p = 1:1:rowB 
                for q = 1:1:colB 
                    if se(p,q) == 1 
                        destRow = i+p-centerRow; 
                        destCol = j+q-centerCol; 
                        if destRow >= 1 && destRow <= RowNum && destCol >= 1 && destCol <= ColNum%�ж������±��Ƿ�Խ�� 
                            imageDilate(destRow,destCol) = se(p,q); 
                        end 
                    end 
                end 
            end 
        end 
    end 
end 
%**************************************************************************