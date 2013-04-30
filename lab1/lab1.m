%lab1

img1=imread('lena.bmp');
if ndims(img1)==3 %如果是彩色图像，将其转换为黑白图
    img2=rgb2gray(img1);
else
    img2=img1;
end
figure; %打开画图窗口
subplot(2,3,1); %两行三列显示图像
imshow(img2);
title('原图');
histgram=zeros(256,1); %256*1 的全0矩阵
[row,col]=size(img2);
n=row*col;
for i=1:row
    for j=1:col
        num=double(img2(i,j))+1;
        histgram(num)=histgram(num)+1;
    end
end
subplot(2,3,4);
plot(histgram);
title('直方图');
cdf(1)=histgram(1);
for i=2:256
   cdf(i)=cdf(i-1)+histgram(i);
end
histgram=zeros(256,1);
for i=1:row
   for j=1:col
        k=img2(i,j);
        img2(i,j)=round(cdf(k)*256/(row*col));
        if(img2(i,j)>255)
            img2(i.j)=255
        end
   end
end
for i=1:row
    for j=1:col
        num=double(img2(i,j))+1;
        histgram(num)=histgram(num)+1;
    end
end
subplot(2,3,2);
imshow(img2);
title('均衡化后图');
subplot(2,3,5);
plot(histgram);
title('直方图');
if ndims(img1)==3
    img2=rgb2gray(img1);
else
    img2=img1;
end
prompt={'请输入αD+b中的参数α:','请输入αD+b中的参数b:'};
def={'1.0','0'};
answer=inputdlg(prompt,'homework1',1,def);
a=str2double(answer{1})
b=str2double(answer{2})
histgram=zeros(256,1);
for i=1:row
   for j=1:col
        img2(i,j)=img2(i,j)*a+b;
        if(img2(i,j)>255)
            img2(i.j)=255
        end
   end
end
for i=1:row
    for j=1:col
        num=double(img2(i,j))+1;
        histgram(num)=histgram(num)+1;
    end
end
subplot(2,3,3);
imshow(img2);
title('灰度拉伸后图');
subplot(2,3,6);
plot(histgram);
title('直方图');