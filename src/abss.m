function val=abss(inp); 
% Function 'abss' prevents the coordinate of test image  
% exceeds the boundary of the original image 
if(inp>1) 
    val=inp; 
else 
    val=1; 
end 