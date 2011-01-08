set grid
set terminal postscript enhanced color lw 2
set output "contact_queries.eps"
set ylabel "Queries performed"
set xlabel "Number of contacts"
plot "./query_averages_10000.log" with line notitle
