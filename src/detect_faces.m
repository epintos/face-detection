function x = detect_faces(img, f, data)
	res = faceDetection(img, f, data)
    axis(data.step8);
    rgb = imread(img);
    imshow(rgb);
    plot_squares(res(:,2), res(:,1), res(:,5))
    axis(data.step1);
	imshow(rgb);
    plot_squares(res(:,2), res(:,1), res(:,5))
%  	scatter(data(:,2),data(:,1), 'g', '*');
	% title('Imagen de deteccion');
    
function plot_squares(xs, ys, ds)
    hold on
    for i = 1:length(xs)
       x = xs(i);
       y = ys(i);
       d = ds(i);  
       xplot = [x - d, x + d, x + d, x - d, x - d];
       yplot = [y - d, y - d, y + d, y + d, y - d];
       plot(xplot, yplot, 'r');
    end
    hold off