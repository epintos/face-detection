function [ctr, hWdth] = ee368boxInfo(row, col) 
% Given the row and column information of the white area of a binary image, 
% this function returns the value of center and width of the squared window. 
% 
% Example 
% [ctr, hWdth] = ee368boxInfo(row, col) 
%   row: row cordinates of the white pixels 
%   col: column cordinates of the white pixels 
%   ctr: (row cordinate of the center, column cordinate of the center) 
%   hWdth: half of the size of the window 
minR = min(row); maxR = max(row); 
minC = min(col); maxC = max(col); 
ctr = round([(minR + maxR)/2, (minC + maxC)/2]); 
hStp = 5; 
if (maxR-minR) > (maxC-minC), 
    hWdth = round((maxR - minR)/2/hStp)*hStp; 
else 
    hWdth = round((maxC - minC)/2/hStp)*hStp; 
end 