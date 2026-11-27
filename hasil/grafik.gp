# Dari folder repositori: gnuplot hasil/grafik.gp
folder = "hasil/"
data = folder."metrik.csv"
set datafile separator ","
set terminal pngcairo size 1680,760 enhanced font "Arial,24" background rgb "white"
set style data histograms
set style histogram clustered gap 1.15
set style fill solid 1.0 noborder
set boxwidth 0.87 relative
set border 3 lw 1.5
set grid ytics back lc rgb "#dddddd"
set tics nomirror out scale 0.5
set key above center horizontal reverse Left samplen 1 spacing 1
set yrange [0:100]
set ytics 20
set lmargin 9
set rmargin 2
set bmargin 2
metode(i) = (i == 0 ? "Linear" : i == 1 ? "Newton kubik" : "PCHIP")
warna(i) = (i == 0 ? "#333333" : i == 1 ? "#124f81" : "#9b430e")
set ylabel "MAE (mm/bulan)"
set output folder."mae.png"
plot for [i=0:2] data every 3::(i+1) using 4:xticlabels(1) title metode(i) lc rgb warna(i)
set ylabel "Kategori cocok (%)"
set output folder."kategori.png"
plot for [i=0:2] data every 3::(i+1) using 6:xticlabels(1) title metode(i) lc rgb warna(i)
unset output
