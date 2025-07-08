function update_pipe_x(top, bottom, new_x, pipe_width)
    top_pos = get(top, 'Position');
    bottom_pos = get(bottom, 'Position');
    set(top, 'Position', [new_x, top_pos(2), pipe_width, top_pos(4)]);
    set(bottom, 'Position', [new_x, bottom_pos(2), pipe_width, bottom_pos(4)]);
end
