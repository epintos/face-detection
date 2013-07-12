function x = detect_faces(img, f)
	data = faceDetection(img, f)
	figure
	rgb = imread(img);
	imshow(rgb);
	hold on
	scatter(data(:,2),data(:,1), 'g', '*');
	hold off
	% title('Imagen de deteccion');