library(reshape2)
strip <- function(string) {
    # Strip leading and trailing spaces
    str_replace(str_replace(string, '^ *', ''), ' *$', '')
}

table5 <- read.fwf(
    'archive/12121400/table5.fixie',
    c(40, 12, 1, 12, 1, 12, 1, 13),
    stringsAsFactors = F
)[-c(2, 7),c(1, 2, 4, 6, 8)]
rownames(table5) <- 1:nrow(table5)
colnames(table5) <- c('transaction', 'A', 'B', 'C', 'total')

table5$direction <- c(rep('income', 5), rep('expense', 6))
