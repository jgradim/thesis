set grid
set terminal postscript enhanced color lw 3
set output "document_queries.eps"
set ylabel "Queries performed"
set xlabel "Number of Blocks in a Document"
set key left
# sampling rate for the constant queries. 36 are needed, to correspond to the discretionary x values
set samples 36
plot "./document_query_averages.log" title "old design" lc rgb "#cc0000", 2 title "new design" with points lc rgb "#0000cc"
