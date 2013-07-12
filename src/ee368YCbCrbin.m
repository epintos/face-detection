function result=ee368YCbCrbin(RGBimage,meanY,meanCb,meanCr,stdY,stdCb,stdCr,factor) 
% ee368YCbCrbin returns binary image with skin-colored area white. 
% 
% Example: 
% result=ee368YCbCrbin(RGBimage,meanY,meanCb,meanCr,stdY,stdCb,stdCr,factor) 
%   RGBimage: double formatted RGB image 
%   meanY:  mean value of Y of skin color 
%   meanCb: mean value of Cb of skin color 
%   meanCr: mean value of Cr of skin color 
%   stdY:   standard deviation of Y of skin color 
%   stdCb:  standard deviation of Cb of skin color 
%   stdCr:  standard deviation of Cr of skin color 
%   factor: factor determines the width of the gaussian envelop. 
% 
% All the parameters are based on the training facial segments taken from 7 training images 
YCbCrimage=rgb2ycbcr(RGBimage); 
% set the range of Y,Cb,Cr 
min_Cb=0.23; %meanCb-stdCb*factor; 
max_Cb=0.47; %meanCb+stdCb*factor; 
min_Cr=0.58; %meanCr-stdCr*factor; 
max_Cr=0.73; %meanCr+stdCr*factor; 
% min_Y=meanY-stdY*factor*2; 
% get a desirable binary image with the acquired range 
imag_row=size(YCbCrimage,1); 
imag_col=size(YCbCrimage,2); 
binImage=zeros(imag_row,imag_col); 
Cb=zeros(imag_row,imag_col); 
Cr=zeros(imag_row,imag_col); 

%Cb(find((YCbCrimage(:,:,2) > min_Cb) & (YCbCrimage(:,:,2) < max_Cb)))=1; 
%Cr(find((YCbCrimage(:,:,3) > min_Cr) & (YCbCrimage(:,:,3) < max_Cr)))=1; 

for i = 1:imag_row
    for j = 1:imag_col,
        if (YCbCrimage(i,j,2) > min_Cb) && (YCbCrimage(i,j,2) < max_Cb),
            Cb(i,j) = 1;
        end
        if (YCbCrimage(i,j,3) > min_Cr) && (YCbCrimage(i,j,3) < max_Cr),
            Cr(i,j) = 1;
        end
    end
end 

binImage=255*(Cb.*Cr); 
result=binImage; 