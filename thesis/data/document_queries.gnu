set grid
set terminal postscript enhanced color lw 2
set output "document_queries.eps"
set ylabel "Queries performed"
set xlabel "Number of Blocks in a Document"
plot "./document_query_averages.log" notitle
