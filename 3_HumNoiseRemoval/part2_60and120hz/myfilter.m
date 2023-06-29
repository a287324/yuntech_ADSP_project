function dst = myfilter(b, a, src)
    % 濾波器係數和訊號長度
    Nb = length(b);
    Na = length(a);
    Nsrc = length(src);
    % 擴展訊號
    x = [zeros(Nb-1, 1); src];
    y = zeros(Nsrc+Na-1, 1);
    % filter
    for n = 1:Nsrc
		xseg = x((n+Nb-1):-1:n);
		yseg = y((n+Na-2):-1:n);
        y(n+Na-1) = dot(xseg, b) - dot(yseg, a(2:end));
    end
	% 取出結果
    dst = y(end-Nsrc+1:end);
end
