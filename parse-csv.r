library(reshape2)
strip <- function(string) {
    # Strip leading dollar sign and leading and trailing spaces
    str_replace(str_replace(string, '^[$]? *', ''), ' *$', '')
}

# Load file
table5.wide <- read.fwf(
    'archive/12121400/table5.fixie',
    c(40, 12, 1, 12, 1, 12, 1, 13),
    stringsAsFactors = F
)[-c(2, 7),c(1, 2, 4, 6, 8)]

# Names
rownames(table5.wide) <- 1:nrow(table5.wide)
colnames(table5.wide) <- c('transaction', 'A', 'B', 'C', 'total')

# Remove spaces.
table5.wide <- data.frame(lapply(table5.wide, strip), stringsAsFactors = F)
table5.wide[-1] <- data.frame(lapply(table5.wide[-1], as.numeric))

# Income or expense?
table5.wide$direction <- c(rep('income', 5), rep('expense', 6))

table5.long <- melt(table5.wide, c('direction', 'transaction'),
    variable.name = 'type.of.depository', value.name = 'amount')
