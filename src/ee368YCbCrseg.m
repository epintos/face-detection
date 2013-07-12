function ee368YCbCrseg 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%% a function for color component analysis  %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% training image size 
size_x=100; 
size_y=100; 
folder=['a' 'b' 'c' 'd' 'e' 'f' 'g']; 
image_q=[13 17 20 14 11 19 12]; 
folder_num=size(image_q); 
n=0; 
% make a YCrCb color matrix set 
for i=1:folder_num(2) 
    for k = 1:image_q(i) 
        if k < 10 face = imread(sprintf('testImages/traincolor_%d/%c0%d.jpg',i,folder(i),k)); 
        else face = imread(sprintf('testImages/traincolor_%d/%c%d.jpg',i,folder(i),k)); 
        end 
        n=n+1; 
        RGBface = double(face); 
        YCbCrface = rgb2ycbcr(RGBface); 
        YCbCrfaces(:,:,:,n)=YCbCrface; 
    end 
end 
% discrimination of each component from the color matrix set 
[m_YCbCr, n_YCbCr, p_YCbCr, num_YCbCr] = size(YCbCrfaces); 
Y = reshape(YCbCrfaces(:,:,1,:),m_YCbCr*n_YCbCr*num_YCbCr,1); 
Cb = reshape(YCbCrfaces(:,:,2,:),m_YCbCr*n_YCbCr*num_YCbCr,1); 
Cr = reshape(YCbCrfaces(:,:,3,:),m_YCbCr*n_YCbCr*num_YCbCr,1); 
% histogram of each component 
subplot(131); hist(Y); title('histogram of Y'); 
subplot(132); hist(Cb); title('histogram of Cb'); 
subplot(133); hist(Cr); title('histogram of Cr'); 
clear all;