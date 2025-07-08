function [top, bottom] = create_pipe(ax, x, gap_y, gap_size, pipe_width)
    top_height = 700 - (gap_y + gap_size / 2);
    bottom_height = gap_y - gap_size / 2;
    top = rectangle(ax, 'Position', [x, gap_y + gap_size/2, pipe_width, top_height], ...
                    'FaceColor', 'green', 'EdgeColor', 'none');
    bottom = rectangle(ax, 'Position', [x, 0, pipe_width, bottom_height], ...
                       'FaceColor', 'green', 'EdgeColor', 'none');
end
