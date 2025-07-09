function result = check_collision(obj1, obj2)
    r1 = get_bounds(obj1);
    r2 = get_bounds(obj2);

    result = ~(r1(1) + r1(3) < r2(1) || ...
               r1(1) > r2(1) + r2(3) || ...
               r1(2) + r1(4) < r2(2) || ...
               r1(2) > r2(2) + r2(4));
end

function bounds = get_bounds(obj)
    if isprop(obj, 'Position')
        pos = get(obj, 'Position');
        bounds = [pos(1), pos(2), pos(3), pos(4)];
    else
        xdata = get(obj, 'XData');
        ydata = get(obj, 'YData');
        width = abs(xdata(2) - xdata(1));
        height = abs(ydata(2) - ydata(1));
        bounds = [xdata(1), ydata(1), width, height];
    end
end
