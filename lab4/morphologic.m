%通用的二值形态学运算（腐蚀和膨胀、开、闭和击中击不中变换）函数 
%************************************************************************** 
function resultImg=morphologic(img,operator) 
%***********************************初始化变量****************************** 
[x,y]=size(img);%获得原图像的大小 
%初始化各个中间变量 
img1=false(x,y); 
img2=false(x,y); 
img3=false(x,y); 
output=false(x,y); 
%********************根据用户选择的操作进行二值形态学运算********************* 
switch operator 
%*********************************腐蚀运算********************************** 
    case 'erosion' 
        se = [1 1 1;1 1 1;1 1 1];%定义结构单元（3*3方形） 
        resultImg = erosion(img,se);%调用腐蚀运算函数进行腐蚀运算 
      
 
%*********************************膨胀运算********************************** 
    case 'dilation' 
        se =[1 1 1;1 1 1;1 1 1];%定义结构单元（3*3方形） 
        resultImg=dilation(img,se);%调用膨胀运算函数进行膨胀运算 
     
%*********************************结构开变换******************************** 
    case 'open' 
        se =[1 1 1;1 1 1;1 1 1];%定义结构单元（3*3方形） 
        %结构开变换是先腐蚀然后再膨胀 
        img1=erosion(img,se); 
        resultImg=dilation(img1,se); 
%*********************************结构闭变换******************************** 
    case 'close' 
        se =[1 1 1;1 1 1;1 1 1];%定义结构单元（3*3方形） 
        %结构开变换是先膨胀然后再腐蚀 
        img1=dilation(img,se); 
        resultImg=erosion(img1,se); 
%*********************************击中击不中变换**************************** 
    case 'hit_miss' 
        se1 = [0 0 0;0 1 1;1 1 1];%定义结构单元 
        se2 = [0 0 0;0 0 0];%定义结构单元 
        %img1=erosion(img,se1); 
        %img2=erosion(~img,se2); 
        %img3=img1&img2; 
        resultImg=erosion(img,se1) & ~dilation(img,se2); 
end 
 
 
 
%*******************************腐蚀运算函数******************************** 
function imageErode = erosion(image,se) 
 
[RowNum,ColNum] = size(image);%取图像的宽度和高度 
[rowB,colB] = size(se);%取结构单元的长度和宽度 
imageErode = false(RowNum,ColNum);%初始化返回图像 
%计算出结构单元的中心位置 
centerRow = floor((rowB+1)/2); 
centerCol = floor((colB+1)/2); 
 
for i = 1:1:RowNum 
    for j = 1:1:ColNum 
        if image(i,j) == 1 
            Erode = 0;%DoErode表示要不要对该点进行腐蚀，初始定义为不腐蚀 
            for p = 1:1:rowB 
                for q = 1:1:colB 
                    destRow = i+p-centerRow; 
                    destCol = j+q-centerCol; 
                    if (destRow >= 1 && destRow <= RowNum && destCol >= 1 && destCol <= ColNum)%判断数组下标是否越界 
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
%*******************************膨胀运算函数******************************** 
function imageDilate = dilation(image,se) 
 
[RowNum,ColNum] = size(image);%取图像的宽度和高度 
[rowB,colB] = size(se);%取结构单元的宽度和高度 
imageDilate = false(RowNum,ColNum);%初始化返回图像 
%计算出结构单元的中心位置 
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
                        if destRow >= 1 && destRow <= RowNum && destCol >= 1 && destCol <= ColNum%判断数组下标是否越界 
                            imageDilate(destRow,destCol) = se(p,q); 
                        end 
                    end 
                end 
            end 
        end 
    end 
end 
%**************************************************************************