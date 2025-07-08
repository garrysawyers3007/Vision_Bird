function update_pipe(top, bottom, new_x, gap_y, gap_size, pipe_width)
    top_height = 700 - (gap_y + gap_size / 2);
    bottom_height = gap_y - gap_size / 2;
    set(top, 'Position', [new_x, gap_y + gap_size/2, pipe_width, top_height]);
    set(bottom, 'Position', [new_x, 0, pipe_width, bottom_height]);
end
