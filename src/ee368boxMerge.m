function boxInfo = ee368boxMerge(boxInfo, num_segments, nRow) 
% Given the information of the squared windows, this function merges superpo- 
% sing squares. Additioally, this function also rejects too small or large 
% windows. 
% 
% Example: 
% boxInfo = ee368boxMerge(boxInfo, num_segments, nRow) 
%   boxInfo: center coordinates and half widths of the boxes 
%   num_segments: number of segments or boxes 
%   rRow:  total number of rows of the given image 
%   boxInfo: newly generated boxInfo 
rGapTh = 70; 
cGapTh = 25; 
hStp = 5; 
rThr = 200; 
adjBoxCor = []; 
for i = 1: num_segments-1, 
    rGap = boxInfo(i+1:end, 1) - boxInfo(i, 1); 
    cGap = boxInfo(i+1:end, 2) - boxInfo(i, 2); 
    rCandi = find((abs(rGap) < rGapTh) & (abs(cGap) < cGapTh)); 
    adjBoxCor = [adjBoxCor; i*ones(length(rCandi),1) i+rCandi]; 
end 

numAdj = size(adjBoxCor,1); 
for j = 1: numAdj, 
    fstPnt = adjBoxCor(j,1); 
    fstCtrR = boxInfo(fstPnt, 1); 
    fstCtrC = boxInfo(fstPnt, 2); 
    fstHwd = boxInfo(fstPnt, 3); 
     
    sndPnt = adjBoxCor(j,2); 
    sndCtrR = boxInfo(sndPnt, 1); 
    sndCtrC = boxInfo(sndPnt, 2); 
    sndHwd = boxInfo(sndPnt, 3);
     
    if fstCtrR-fstHwd < sndCtrR-sndHwd, 
        rTop = fstCtrR-fstHwd; 
    else 
        rTop = sndCtrR-sndHwd; 
    end 
     
    if fstCtrR+fstHwd > sndCtrR+sndHwd, 
        rBot = fstCtrR+fstHwd; 
    else
        rBot = sndCtrR+fstHwd; 
    end 
     
    if fstCtrC-fstHwd < sndCtrC-sndHwd, 
        cLeft = fstCtrC-fstHwd; 
    else 
        cLeft = sndCtrC-sndHwd; 
    end 
     
    if fstCtrC+fstHwd > sndCtrC+sndHwd, 
        cRight = fstCtrC+fstHwd; 
    else 
        cRight = sndCtrC+sndHwd; 
    end 
     
    ctr = round([(rTop+rBot)/2, (cLeft+cRight)/2]); 
    if rBot-rTop > cRight-cLeft, 
        hWdth = round((rBot-rTop)/2/hStp)*hStp; 
    else 
        hWdth = round((cRight-cLeft)/2/hStp)*hStp; 
    end 
         
    boxInfo(sndPnt, :) = [ctr, hWdth]; 
    boxInfo(fstPnt, :) = [ctr, hWdth]; % added line 
end 
adjBoxCor2 = adjBoxCor; 
for i = 2: size(adjBoxCor, 1), 
    if adjBoxCor(i,1) == adjBoxCor(i-1,1), 
        adjBoxCor2(i,1) = adjBoxCor(i-1, 2); 
    end 
end 
boxInfo(adjBoxCor2(:,1), :) = []; 

% boxInfo(find(boxInfo(:,1) > nRow-rThr), :) = [];