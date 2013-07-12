function  fCorr = ee368imgMatchFe(testImg, hWdth) 
% Image matching for a female image 
lowThr = 40; 
higThr = 220; 
wdth = 2*hWdth; 
if wdth < lowThr, 
    fCorr = [0 0 0]; 
elseif wdth > higThr,  
    fCorr = [0 0 0]; 
else 
    eigFacePath1 = strcat('../eigenfaces/fImg1_', num2str(wdth), '.jpg');
    eigFace1 = rgb2ycbcr(im2double(imread(eigFacePath1)));
    eigFace1 = reshape(eigFace1(:,:,1), wdth^2, 1);
    
    eigFacePath2 = strcat('../eigenfaces/fImg2_', num2str(wdth), '.jpg');
    eigFace2 = rgb2ycbcr(im2double(imread(eigFacePath2)));
    eigFace2 = reshape(eigFace2(:,:,1), wdth^2, 1);
    
    eigFacePath3 = strcat('../eigenfaces/fImg3_', num2str(wdth), '.jpg');
    eigFace3 = rgb2ycbcr(im2double(imread(eigFacePath3)));
    eigFace3 = reshape(eigFace3(:,:,1), wdth^2, 1);
    
    fImg = [eigFace1 eigFace2 eigFace3];
    fCorr = reshape(testImg, wdth^2, 1)' * fImg; 
    
%     eval(['load fImg1_', num2str(wdth)]); 
%     eval(['load fImg2_', num2str(wdth)]); 
%     eval(['load fImg3_', num2str(wdth)]); 
%     fImg = [fImg1 fImg2 fImg3];  
%     fCorr =reshape(testImg, 1, wdth^2)*fImg; 
end 