function val=abss2(inp, thr); 
% Function 'abss' prevents the coordinate of test image  
% exceeds the boundary of the original image 
if(inp>thr) 
    val=thr; 
else 
    val=inp; 
end