function flappy_bird_main
    persistent high_score; %global
    if isempty(high_score)
        high_score = 0;
    end
    addpath('.\images\');

    fig = figure('Color', 'white', ...
                 'MenuBar', 'none', 'ToolBar', 'none', ...
                 'NumberTitle', 'off', 'Name', 'Flappy Bird', ...
                 'Position', [100 100 1000 500]);

    show_start_screen();

    function show_start_screen()
        clf(fig);

        uicontrol('Style', 'text', ...
                  'String', ['High Score: ' num2str(high_score)], ...
                  'FontSize', 14, ...
                  'Position', [350 300 300 60], ...
                  'BackgroundColor', 'white');
        
        uicontrol('Style', 'pushbutton', 'String', 'Start Game', ...
                  'FontSize', 14, ...
                  'Position', [420 200 160 50], ...
                  'Callback', @(~,~) ask_for_custom_bird());
    end

    function ask_for_custom_bird()
        clf(fig);

        uicontrol('Style', 'text', ...
                  'String', 'Do you want to use your face as the bird?', ...
                  'FontSize', 14, ...
                  'Position', [300 300 400 60], ...
                  'BackgroundColor', 'white');

        uicontrol('Style', 'pushbutton', 'String', 'Yes', ...
                  'FontSize', 14, ...
                  'Position', [300 200 150 50], ...
                  'Callback', @(~,~) start_game_from_calibration(true));

        uicontrol('Style', 'pushbutton', 'String', 'No', ...
                  'FontSize', 14, ...
                  'Position', [550 200 150 50], ...
                  'Callback', @(~,~) start_game_from_calibration(false));
    end

    function start_game_from_calibration(use_face)
        [cam, Hmin, Hmax, Smin, Smax, Vmin, Vmax, face_img] = calibrate_color(use_face);
        start_game(fig, cam, Hmin, Hmax, Smin, Smax, Vmin, Vmax, @show_start_screen, face_img, use_face);
    end
end
