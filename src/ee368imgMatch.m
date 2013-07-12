function corr = ee368imgMatch(testImg, hWdth) 
% This function correlates a given test image with 
% a reference image which has a tailored image size 
% and is called from the database. 
% 
% Example 
% corr = ee368imgMatch(testImg, hWdth) 
%   testImg: square shaped test image 
%   hWdth: half of the width of the testImg 
%   corr: correlation value 
lowThr = 30; 
higThr = 200; 
wdth = 2*hWdth; 
if wdth < lowThr, 
    corr = 0; 
elseif wdth > higThr,  
    corr = 0; 
else 
% 	eval(['eigFace = load(''../eigenfaces/eigFace', num2str(wdth), '.jpg'');']); 

    eigFacePath = strcat('../eigenfaces/eigFace', num2str(wdth), '.jpg');
    eigFace = rgb2ycbcr(im2double(imread(eigFacePath)));
    corr = reshape(testImg, wdth^2, 1)' * reshape(eigFace(:,:,3), wdth^2, 1); 
end 
