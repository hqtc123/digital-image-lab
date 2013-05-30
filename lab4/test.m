img = imread('word_bw.bmp'); 
figure;
subplot(2,3,1);
imshow(img), title('原始图像'); 
%*********************************腐蚀运算********************************** 
img1=morphologic(img,'erosion'); 
subplot(2,3,2);
imshow(img1), title('腐蚀变换');
%*********************************膨胀运算********************************** 
img2=morphologic(img,'dilation'); 
subplot(2,3,3);
imshow(img2), title('膨胀变换');
%*********************************结构开变换******************************** 
img3=morphologic(img,'open'); 
subplot(2,3,4);
imshow(img3),title('结构开变换');
%*********************************结构闭变换******************************** 
img4=morphologic(img,'close'); 
subplot(2,3,5);
imshow(img4),title('结构闭变换');
%*********************************击中击不中变换**************************** 
morphologic(img,'hit_miss');
subplot(2,3,6);
imshow(img3),title('击中击不中变换');