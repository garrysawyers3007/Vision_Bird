function [cam, Hmin, Hmax, Smin, Smax, Vmin, Vmax, face_img] = calibrate_color(use_face)
    % cam = webcam('Logitech Webcam C925e');
    cam = webcam();

     if use_face
        clf;
        % Show a frame and let user draw a rectangle
        frame = snapshot(cam);
        h = imshow(frame);
        title('Draw a box around your face and double click');
        rect = drawrectangle();

        % Crop and store face image
        face_img = imcrop(frame, rect.Position);
    end
    
    pause(1);
    frame = snapshot(cam);

    hCalib = figure('Name', 'Calibration - Draw box around object', ...
                    'Position', [200 200 640 480]);
    imshow(frame);
    title('Draw box around the colored object');
    roi = drawrectangle('Color', 'r');
    pos = round(roi.Position);
    objectROI = imcrop(frame, pos);
    close(hCalib);

    objectHSV = rgb2hsv(objectROI);
    H = objectHSV(:,:,1);
    S = objectHSV(:,:,2);
    % V = objectHSV(:,:,3);

    Hmin = max(min(H(:)) - 0.05, 0); Hmax = min(max(H(:)) + 0.05, 1);
    Smin = max(min(S(:)) - 0.2, 0);  Smax = 1;
    Vmin = 0.2; Vmax = 1;

   
end
