function start_game(fig, cam, Hmin, Hmax, Smin, Smax, Vmin, Vmax, show_start_screen)
    persistent high_score;
    if isempty(high_score), high_score = 0; end

    clf(fig);

    % Axes layout
    axGame = axes('Parent', fig, 'Units', 'normalized', 'Position', [0.05 0.1 0.55 0.85]);
    axCam  = axes('Parent', fig, 'Units', 'normalized', 'Position', [0.65 0.55 0.3 0.35]);
    axMask = axes('Parent', fig, 'Units', 'normalized', 'Position', [0.65 0.1 0.3 0.35]);

    axis(axGame, [0 500 0 700]); axis manual; daspect(axGame, [1 1 1]);
    set(axGame, 'XColor', 'none', 'YColor', 'none', 'box', 'off', 'Color', 'white');
    hold(axGame, 'on');
    rectangle(axGame, 'Position', [0 0 500 700], 'EdgeColor', [0.2 0.2 0.2], 'LineWidth', 2);

    % Gameplay constants
    speeding_factor = 2;
    gravity = -0.6 * speeding_factor^2;
    jump_velocity = 10 * speeding_factor;
    pipe_speed = 2.5 * speeding_factor;

    pipe_width = 60; pipe_spacing = 300;
    min_gap_y = 180; max_gap_y = 520;
    min_gap_size = 140; max_gap_size = 240;

    % Bird
    bird_x = 100; bird_y = 350; bird_vy = 0;
    bird_size = [30 30];
    bird = rectangle(axGame, 'Position', [bird_x bird_y bird_size], 'FaceColor', 'yellow');

    % Pipes
    num_pipes = 3;
    pipes = gobjects(num_pipes, 2); pipe_xs = zeros(1, num_pipes); gap_sizes = zeros(1, num_pipes);
    for i = 1:num_pipes
        x = 500 + (i-1)*pipe_spacing;
        gap_size = randi([min_gap_size max_gap_size]);
        gap_y = randi([min_gap_y max_gap_y]);
        [top, bottom] = create_pipe(axGame, x, gap_y, gap_size, pipe_width);
        pipes(i,:) = [top, bottom]; pipe_xs(i) = x; gap_sizes(i) = gap_size;
    end

    % Score
    score = 0;
    scoreText = text(axGame, 20, 660, "Score: 0", 'FontSize', 14, 'FontWeight', 'bold');
    highScoreText = text(axGame, 20, 630, ['High Score: ' num2str(high_score)], ...
                         'FontSize', 12, 'Color', [0.4 0.4 0.4]);

    % Flap detection setup
    frame = snapshot(cam);
    [frameH, frameW, ~] = size(frame);
    zoneW = round(frameW * 0.2); zoneH = round(frameH * 0.5);
    mirroredLeftZone = [frameW - zoneW + 1, 1, zoneW, zoneH];
    mirroredRightZone = [1, 1, zoneW, zoneH];
    pixelThreshold = 10; inZonePreviously = false;

    % Main loop
    running = true;
    while running && ishandle(fig)
        % ---- Webcam input and flap detection ----
        frame = fliplr(snapshot(cam));
        hsvFrame = rgb2hsv(frame);
        mask = (hsvFrame(:,:,1) >= Hmin & hsvFrame(:,:,1) <= Hmax) & ...
               (hsvFrame(:,:,2) >= Smin & hsvFrame(:,:,2) <= Smax) & ...
               (hsvFrame(:,:,3) >= Vmin & hsvFrame(:,:,3) <= Vmax);
        mask = bwareaopen(mask, 300); % basic cleanup

        leftMask  = mask(1:zoneH, mirroredLeftZone(1):mirroredLeftZone(1)+zoneW-1);
        rightMask = mask(1:zoneH, mirroredRightZone(1):mirroredRightZone(1)+zoneW-1);
        leftActive = nnz(leftMask) >= pixelThreshold;
        rightActive = nnz(rightMask) >= pixelThreshold;
        bothIn = leftActive && rightActive; bothOut = ~leftActive && ~rightActive;

        if inZonePreviously && bothOut
            bird_vy = jump_velocity;
            inZonePreviously = false;
        elseif bothIn
            inZonePreviously = true;
        end

        % ---- Visual update: webcam + mask ----
        frame = insertShape(frame, 'Rectangle', [mirroredLeftZone; mirroredRightZone], ...
                            'Color', 'blue', 'LineWidth', 5);
        stats = regionprops(mask, 'BoundingBox');
        for i = 1:numel(stats)
            frame = insertShape(frame, 'Rectangle', stats(i).BoundingBox, 'Color', 'green');
        end
        imshow(frame, 'Parent', axCam);
        imshow(mask, 'Parent', axMask);

        % ---- Game logic ----
        bird_vy = bird_vy + gravity;
        bird_y = bird_y + bird_vy;
        set(bird, 'Position', [bird_x bird_y bird_size]);

        for i = 1:num_pipes
            pipe_xs(i) = pipe_xs(i) - pipe_speed;
            if pipe_xs(i) + pipe_width < 0
                pipe_xs(i) = max(pipe_xs) + pipe_spacing;
                gap_sizes(i) = randi([min_gap_size max_gap_size]);
                gap_y = randi([min_gap_y max_gap_y]);
                update_pipe(pipes(i,1), pipes(i,2), pipe_xs(i), gap_y, gap_sizes(i), pipe_width);
                score = score + 1;
                scoreText.String = ['Score: ' num2str(score)];
                if score > high_score
                    high_score = score;
                    highScoreText.String = ['High Score: ' num2str(high_score)];
                end
            else
                update_pipe_x(pipes(i,1), pipes(i,2), pipe_xs(i), pipe_width);
            end
        end

        for i = 1:num_pipes
            if check_collision(bird, pipes(i,1)) || check_collision(bird, pipes(i,2))
                show_game_over();
                return;
            end
        end

        if bird_y <= 0 || bird_y + bird_size(2) >= 700
            show_game_over();
            return;
        end

        drawnow limitrate;
        pause(0.01);
    end
    
    function show_game_over()
        text(axGame, 180, 350, "Game Over", 'FontSize', 24, 'Color', 'r');
        uicontrol('Style', 'pushbutton', 'String', 'Restart', ...
                  'Position', [200 10 100 30], ...
                  'Callback', @(~,~) start_game(fig, cam, Hmin, Hmax, Smin, Smax, Vmin, Vmax, show_start_screen));
        uicontrol('Style', 'pushbutton', 'String', 'Exit', ...
                  'Position', [320 10 100 30], ...
                  'Callback', @(~,~) show_start_screen());
    end
end
