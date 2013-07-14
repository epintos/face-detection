function outFaces = faceDetection(file, type, handles, params) 
global detector;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Function 'outFaces' returns the matrix with the information of 
% face locations and gender. 
% 
% outFaces = faceDetection(img) 
%  img: double formatted image matrix 
% coefficients 
img = im2double(imread(file, type));

effect_num=2;
if isfield(detector.params,'effect_num')
   effect_num = detector.params.effect_num
end

% Minimum face size
min_face=150;
if isfield(detector.params,'min_face')
   min_face = detector.params.min_face
end

small_area=100;

if isfield(detector.params,'small_area')
   small_area = detector.params.small_area
end

imgSize = size(img); 
uint8Img = uint8(img); 
gray_img=rgb2gray(uint8Img); 
% get the image tranformed through YCbCr filter 
filtered=ee368YCbCrbin(img,161.9964,-11.1051,22.9265,25.9997,4.3568,3.9479,2); 

if isfield(handles, 'step1')
    axes(handles.step1);
    imshow(filtered); 
    detector.steps.step1 = filtered;
    if (detector.params.show_steps)
        axes(handles.target);
        imshow(filtered); 
    end
end

% black isolated holes rejection  
filtered=bwfill(filtered,'holes'); 
if isfield(handles, 'step2')
    axes(handles.step2);
    imshow(filtered);
    detector.steps.step2 = filtered;
    if (detector.params.show_steps)
        axes(handles.target);
        imshow(filtered); 
    end
end

% white isolated holes less than small_area rejection 
filtered=bwareaopen(filtered,small_area*10);  

if isfield(handles, 'step3')
    axes(handles.step3);
    imshow(filtered);
    detector.steps.step3 = filtered;
    if (detector.params.show_steps)
        axes(handles.target);
        imshow(filtered); 
    end
end

% first erosion 
filtered = imerode(filtered,ones(2*effect_num)); 

if isfield(handles, 'step4')
    axes(handles.step4);
    imshow(filtered);
    detector.steps.step4 = filtered;
    if (detector.params.show_steps)
        axes(handles.target);
        imshow(filtered); 
    end
end

% edge detection with the Roberts method with sensitivity 0.1 
edge_img=edge(gray_img,'roberts',0.2); 
% final binary edge image 
edge_img=~edge_img; 
% integeration of two images, edge + filtered image 
filtered=255*(double(filtered) & double(edge_img)); % double 
% second erosion 
filtered=imerode(filtered,ones(effect_num)); 

if isfield(handles, 'step5')
    axes(handles.step5);
    imshow(filtered);
    detector.steps.step5 = filtered;
    if (detector.params.show_steps)
        axes(handles.target);
        imshow(filtered); 
    end
end

% black isolated holes rejection 
filtered=bwfill(filtered,'hole'); 

if isfield(handles, 'step6')
    axes(handles.step6);
    imshow(filtered);
    detector.steps.step6 = filtered;
    if (detector.params.show_steps)
        axes(handles.target);
        imshow(filtered); 
    end
end

% small areas less than the minumum area of face rejection 
filtered=bwareaopen(filtered,min_face); 

if isfield(handles, 'step7')
    axes(handles.step7);
    imshow(filtered);
    detector.steps.step7 = filtered;
    if (detector.params.show_steps)
        axes(handles.target);
        imshow(filtered); 
    end
end


% group labeling in the filtered image 
[segments, num_segments] = bwlabel(filtered); 

% Based on the binary image, squared windows are generated 
boxInfo = []; 
for i = 1:num_segments, 
    [row col] = find(segments == i); 
    [ctr, hWdth] = ee368boxInfo(row, col); 
    boxInfo = [boxInfo; ctr hWdth]; 
end 
% Overlapping squares are merged 
boxInfo = ee368boxMerge(boxInfo, num_segments, imgSize(1)); 

num_box = length(boxInfo); 
% mean squared distance of the boxes with respect to others are calculated 
boxDist = [];  
for i = 1:num_box, 
    boxDist = [boxDist; sqrt((sum((boxInfo(:,1) - boxInfo(i,1)).^2) + ... 
            sum((boxInfo(:,2) - boxInfo(i,2)).^2))/(num_box-1))]; 
end 
     
% conversion to 'double' format and 'gray' format 
gdOrgImg = double(rgb2gray(uint8Img)); 
filtered = double(filtered); 

outFaces = [];
for k=1:num_box, 
    ctr = boxInfo(k, 1:2); 
    hWdth = boxInfo(k,3); 
     
    % Based on the box information, images are cut into squares 
    testImg = ee368imgCut(gdOrgImg, filtered, imgSize, boxInfo(k,:)); 
    
    % normalized with an average brightness 
    avgBri = sqrt(sum(sum(testImg.^2))/bwarea(testImg)); 
    testImg = testImg/avgBri; 
     
    % test images are compared to the eigen images or femaale average images 
    corr = ee368imgMatch(testImg, hWdth); 
    
    fCorr = ee368imgMatchFe(testImg, hWdth); 
    
    outFaces = [outFaces; ctr 1 corr/boxDist(k), hWdth, fCorr]; 
    
%     outFaces = [outFaces; ctr 1 1, hWdth, [1, 1, 1]]; 
    
%     imwrite(testImg, strcat('../garbage/img', num2str(corr),'.jpg'));
end 

% sorting of the correlation values 
[Y I] = sort(outFaces(:,4)); 
outFaces = outFaces(I, :); 
% elimination of small correlation values using histogram 
B = hist(Y); 
if B(1) < 0.5*num_box,
    outFaces = outFaces(B(1)+1:end, :); 
end 

% Remotion of false faces by geographic location
[Y I] = sort(outFaces(:,1)); 
outFaces = outFaces(I, :); 
% elimination of small correlation values using histogram 
num_box = size(outFaces, 1);
B = hist(Y, 3); 
num_to_remove = B(end);
if num_to_remove < 0.5 * num_box,
	outFaces = outFaces(1:end - num_to_remove, :); 
end 

% results of the correlation with respect to the women's faces 
[Fe1, ordFe1] = max(outFaces(:, 6)); 
[Fe2, ordFe2] = max(outFaces(:, 7)); 
[Fe3, ordFe3] = max(outFaces(:, 8)); 
outFaces([ordFe1, ordFe2, ordFe3],3) = 2;