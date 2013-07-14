function x = detect_faces(img, f, handles, params)
    global detector;
    res = faceDetection(img, f, handles)
    axes(handles.target);
    rgb = im2double(imread(img, f));
	imshow(rgb);
    detector.params.res = res;
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