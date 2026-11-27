function [x, H, q] = simpul_valid(x, H, q, n, kiri, kanan)
  for v = {x, H, q}
    z = v{1};
    if !isnumeric(z) || !isvector(z) || isempty(z) || !isreal(z) || any(!isfinite(z(:)))
      error('metnum:masukan', 'x, H, dan kueri harus berupa vektor numerik riil berhingga.');
    endif
  endfor
  if numel(x) != n || numel(H) != n
    error('metnum:masukan', 'x dan H masing-masing harus memuat %d simpul.', n);
  endif
  x = double(x(:));
  H = double(H(:));
  q = double(q);
  if any(diff(x) <= 0)
    error('metnum:masukan', 'Absis harus meningkat ketat tanpa simpul duplikat.');
  endif
  if any(q(:) < x(kiri) | q(:) > x(kanan))
    error('metnum:masukan', 'Kueri di luar domain [%g, %g].', x(kiri), x(kanan));
  endif
endfunction
