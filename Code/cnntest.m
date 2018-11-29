function [h, val, out] = cnntest(net, x)
    %  feedforward
    net = cnnff(net, x);
    out = net.o;
    [val, h] = max(net.o);
    %[~, a] = max(y);
    %bad = find(h ~= a);

    %er = numel(bad) / size(y, 2);
end
