function testImg = ee368imgCut(img, filtered, imgSize, boxInfo); 
% This function returns a squared test image with a standardized image size. 
% The output image is masked with a binary image so that non-facial area 
% is blacked out. In addition, this program also compensates for the image 
% which is adjacent to the edge of the picture to make it square formed by 
% means of filling out zeros. 
% 
% Example 
% testImg = ee368imgCut(img, filtered, imgSize, boxInfo) 
%   img: double formatted test image 
%   filtered: binary image which contains mask information 
%   imgSize: the size of img 
%   boxInfo: information of center point and width of a box 
%   testImg: square shaped segment to be tested in image matching algorithm 
nRow = imgSize(1); 
nCol = imgSize(2); 
ctr = boxInfo(1:2); 
hWdth = boxInfo(3); 
testImg = img(abss(ctr(1)-hWdth): abss2(ctr(1)+hWdth-1, nRow), abss(ctr(2)-hWdth): abss2(ctr(2)+hWdth-1, nCol)); 
maskImg = filtered(abss(ctr(1)-hWdth): abss2(ctr(1)+hWdth-1, nRow), abss(ctr(2)-hWdth): abss2(ctr(2)+hWdth-1, nCol)); 
testImg = testImg.*maskImg; 
[nRowOut, nColOut] = size(testImg); 
if ctr(1)-hWdth-1 < 0, % image is sticking out to the top 
    testImg = [zeros(-ctr(1)+hWdth+1, nColOut); testImg]; 
elseif ctr(1)+hWdth-1 > nRow, % image is sticking out to the bottom 
    testImg = [testImg; zeros(ctr(1)+hWdth-nRow-1, nColOut)]; 
end 
if ctr(2)-hWdth -1 < 0, % image is sticking out to the left 
        testImg = [zeros(2*hWdth, -ctr(2)+hWdth+1), testImg]; 
elseif ctr(2)+hWdth-1 > nCol, % image is sticking out to the right 
        testImg = [testImg zeros(2*hWdth, ctr(2)+hWdth-nCol-1)]; 
end 