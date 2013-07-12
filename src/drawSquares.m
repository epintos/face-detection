function img = drawSquares(file, type) 

outFaces = faceDetection(file, type);
img = im2double(imread(file, type));

numFaces = size(outFaces);
for i = 1 : numFaces(1),
    xCenter = outFaces(i,1);
    yCenter = outFaces(i,2);
    hLength = outFaces(i,5);
    
    for j = -hLength : hLength,
        img(xCenter + j, yCenter - hLength, :) = [1 0 0];
        img(xCenter + j, yCenter + hLength, :) = [1 0 0];
        img(xCenter - hLength, yCenter + j, :) = [1 0 0];
        img(xCenter + hLength, yCenter + j, :) = [1 0 0];
        
        img(xCenter + j, yCenter - hLength - 1, :) = [1 0 0];
        img(xCenter + j, yCenter + hLength - 1, :) = [1 0 0];
        img(xCenter - hLength - 1, yCenter + j, :) = [1 0 0];
        img(xCenter + hLength - 1, yCenter + j, :) = [1 0 0];
        
        img(xCenter + j, yCenter - hLength + 1, :) = [1 0 0];
        img(xCenter + j, yCenter + hLength + 1, :) = [1 0 0];
        img(xCenter - hLength + 1, yCenter + j, :) = [1 0 0];
        img(xCenter + hLength + 1, yCenter + j, :) = [1 0 0];
    end
end 

imwrite(img, '~/Desktop/a.jpg');
