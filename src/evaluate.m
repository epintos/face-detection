
%%% EE368 Project Spring 2003
%%% Face Detection Evaluation Program - Chuo-Ling Chang
%%%
%%% INPUT:
%%%       1. filename of the training image (or the test image)
%%%       2. filename of the corresponding ground truth data
%%%       3. weighting factor of the bonus
%%% 
%%% OUTPUT: 
%%%       1. finalScore = p*bonus + detectScore
%%%       2. detectScore = numHit - numRepeat - numFalsePositive (from ouput 3,4,5)
%%%       3. numHit = number of faces succesfully detected
%%%       4. numRepeat = number of faces repeatedly detected
%%%       5. numFalsePositive = number of cases where a non-face is reported
%%%       6. distance = root mean squared distance between detected point and centroid of the ground truth face
%%%       7. runTime = run time of your face detection routine
%%%       8. bonus = max(0, number of correctly recognized female faces - number of male faces falsely recognized as female).
%%%
%%% EXMAPLE:
%%% 
%%%      [finalScore, detectScore, numHit, numRepeat, numFalsePositive, distance, runTime, bonus] ...
%%%       = evaluate('Training_1.jpg','ref1.png', 1.0)
%%%
%%%
%%%
%%% Your main routine has to be in this format:  function outFaces = faceDetection(inImage). 
%%%
%%% INPUT: a image matrix formed by 'inImage = double(imread(imageFilename))'.
%%% 
%%% OUTPUT: a N-by-3 matrix named 'outFaces' containg the coodinates and the color-index for each detected face
%%%         -- N is the number of faces you've detected
%%%         -- outFaces(:,1) contains the detected vertical coordinates (row index of the image matrix)
%%%         -- outFaces(:,2) contains the detected horizontal coordinates (column index of the image matrix)
%%%         -- outFaces(:,3) contains the gender of the detected faces (1 for male, 2 for female)
%%%
%%% NOTE: The gender recognition part is considered as a bonus of the project. If you decide not to do it,
%%% simply set the elements in outFaces(:,3) to any integer. However, your still have to return a N-by-3 matrix.

function [finalScore, detectScore, numHit, numRepeat, numFalsePositive, distance, runTime, bonus] = evaluate(inImageFilename, refImageFilename, p)

% Read input image and reference image
inImage = double(imread(inImageFilename));
refImage = imread(refImageFilename);

startTime = clock;
outFaces = faceDetection(inImage);
endTime = clock;

% Compute elapsed time
runTime = etime(endTime,startTime);

% Count how many faces are correctly detected and recognized
[numHit,numRepeat,numFalsePositive,distance,inImage,bonus] = countFaces(outFaces,inImage,refImage);
detectScore = numHit - numRepeat - numFalsePositive;
bonus = max([0,bonus]);
finalScore = p*bonus + detectScore;

outimg = 'result.jpg';
outtxt = 'result.txt';
outmat = 'result';

imwrite(uint8(inImage),outimg);
fout = fopen(outtxt,'w');
fprintf(fout,' finalScore: %.3f\n detectScore: %d\n numHit: %d\n numRepeat: %d\n numFalsePositive: %d\n distance: %.4f\n runTime: %.2f\n bonus: %d\n',...
    finalScore,detectScore,numHit,numRepeat,numFalsePositive,distance,runTime,bonus);
fclose(fout);
save(outmat,'finalScore','detectScore','numHit','numRepeat','numFalsePositive','distance','runTime','bonus');





%%% Local Function
%%% Count how many faces are correctly detected and recognized
function [numHit,numRepeat,numFalsePositive,distance,inImage,bonus] = countFaces(outFaces,inImage,refImage)

% define colors
red = [255 0 0];
yellow = [255 255 0];
cyan = [0 255 255];
green = [0 255 0];
inImage = uint8(inImage);

% number of detected image
numFoundFaces = size(outFaces,1);
numHit = 0;
numRepeat = 0;
numFalsePositive = 0;
bonus = 0;

% label each face in the reference image with a number
% non-face will be labeled as 0
refImageLabeled = bwlabel(refImage);
numFaces = max(refImageLabeled(:));
hit = zeros(numFaces,1);
sq_dist = zeros(numFaces,1);
centroid = zeros(numFaces,2);

for c = 1:numFaces
    face = find(refImageLabeled==c);
    [face_y,face_x] = ind2sub(size(refImageLabeled),face);
    centroid(c,1) = mean(face_y);
    centroid(c,2) = mean(face_x);
end

for i = 1:numFoundFaces
    found_y = outFaces(i,1);
    found_x = outFaces(i,2);
    currentLabel = refImageLabeled(found_y,found_x);
    
    if (currentLabel~=0) % point on a face
        
        if ~hit(currentLabel) % newly detected face            
            
            hit(currentLabel) = 1;
            color = cyan;
            sq_dist(currentLabel) = (found_y-centroid(currentLabel,1))^2 + (found_x-centroid(currentLabel,2))^2;            
            
            if (outFaces(i,3)==2)
                color = green;
                if (refImage(found_y,found_x)==2)
                    bonus = bonus + 1;
                else
                    bonus = bonus - 1;
                end
            end
            
        else % repeatedly detected face
            
            numRepeat = numRepeat + 1;
            color = yellow;
            sq_dist_temp = (found_y-centroid(currentLabel,1))^2 + (found_x-centroid(currentLabel,2))^2;
            if (sq_dist_temp<sq_dist(currentLabel))
                sq_dist(currentLabel) = sq_dist_temp;
            end
            
        end        
        
    else % point not on a face
        
        numFalsePositive = numFalsePositive + 1;
        color = red;
        
    end
    
    % label the point
    [imgh,imgw] = size(inImage(:,:,1));
    x = found_x;
    y = found_y;
    xmin = max(1,x-3);
    xmax = min(imgw,x+3);
    ymin = max(1,y-12);
    ymax = min(imgh,y+12);
    xl = xmax - xmin + 1;
    yl = ymax - ymin + 1;
    inImage(ymin:ymax,xmin:xmax,1) = color(1)*ones(yl,xl);
    inImage(ymin:ymax,xmin:xmax,2) = color(2)*ones(yl,xl);
    inImage(ymin:ymax,xmin:xmax,3) = color(3)*ones(yl,xl);
    xmin = max(1,x-12);
    xmax = min(imgw,x+12);    
    ymin = max(1,y-3);
    ymax = min(imgh,y+3);
    xl = xmax - xmin + 1;
    yl = ymax - ymin + 1;
    inImage(ymin:ymax,xmin:xmax,1) = color(1)*ones(yl,xl);
    inImage(ymin:ymax,xmin:xmax,2) = color(2)*ones(yl,xl);
    inImage(ymin:ymax,xmin:xmax,3) = color(3)*ones(yl,xl);
        
end

numHit = sum(hit);
sq_dist = sq_dist(find(hit));
distance = sqrt(mean(sq_dist));


