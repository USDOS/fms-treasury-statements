#!/usr/bin/env Rscript
library(reshape2)
library(stringr)

strip <- function(string) {
    # Strip leading and trailing spaces
    str_replace(str_replace(string, '^ *', ''), ' *$', '')
}

number <- function(string){
    # Remove the leading dollar sign, remove commas, and convert to numeric.
    as.numeric(str_replace_all(str_replace(strip(string), '^[$]?(?:[0-9]/)?', ''), ',', ''))
}

#                                                                Opening balance
#                                          Closing   ______________________________________
#           Type of account                balance                    This         This
#                                           today        Today        month       fiscal
#                                                                                  year
#___________________________________________________________________________________________
 

table1 <- function() {
    # Load file
    table1.wide <- read.fwf(
        'archive/12121400/table1.fixie',
        c(40, 12, 1, 12, 1, 12, 1, 13),
        stringsAsFactors = F
    )[,-c(3, 5, 7)]
    colnames(table1.wide) <- c('type', 'closing.balance.today', 'today', 'this.month', 'this.fiscal.year')
    table1.wide[2, 1] <- paste(strip(table1.wide[2:3, 1]), collapse = ' ')
    table1.wide <- table1.wide[-3,]

    table1.wide[1] <- strip(table1.wide[,1])
    table1.wide[-1] <- data.frame(lapply(table1.wide[-1], number))

    table1.wide
}


#___________________________________________________________________________________________
#     TABLE II  Deposits and Withdrawals of Operating Cash
#___________________________________________________________________________________________
#                                                                    This         Fiscal
#                    Deposits                          Today         month         year
#                                                                   to date      to date
#___________________________________________________________________________________________
#
#Federal Reserve Account:
#  Agriculture Loan Repayments (misc)              $          27 $         472 $       1,296


# Date,Table,Item,Type,Subitem,Today,MTD,FYT,Footnotes
# 11/29/2012,2,Agriculture Loan Repayments (misc),Deposits,,27,472,"1,296",

table2 <- function(datestamp) {
    # Load file
    table2.wide <- read.fwf(
        paste('archive', datestamp, 'table2.fixie', sep = '/'),
        c(51, 13, 1, 13, 1, 13),
        stringsAsFactors = F
    )[,-c(3, 5)]

    table2.wide[1] <- strip(table2.wide[,1])

    colnames(table2.wide) <- c('item', 'today', 'mtd', 'ytd')
    table2.wide$date <- datestamp
    table2.wide$table <- 2

    table2.wide$type <- factor(c(rep('deposit', 34), rep('withdrawal', 45)))
    table2.wide$is.total <- 0
    table2.wide[c(26, 30, 73, 79),'is.total'] <- 1

    table2.wide$subitem <- ''
    table2.wide[7:8,'subitem'] <- table2.wide[7:8,'item']
    table2.wide[7:8,'item'] <- 'Deposits by States' # table2.wide[6,'item']

    table2.wide[22:26,'subitem'] <- table2.wide[22:26,'item']
    table2.wide[22:26,'item'] <- 'Other Deposits' # table2.wide[21,'item']
    table2.wide[26,'subitem'] <- ''

    table2.wide[33,'subitem'] <- table2.wide[33,'item']
    table2.wide[33,'item'] <- 'Short-Term Cash Investments' # table2.wide[31,'item']

    table2.wide[65:72,'subitem'] <- table2.wide[65:72,'item']
    table2.wide[65:73,'item'] <- 'Other Withdrawals' # table2.wide[64,'item']
    table2.wide[73,'subitem'] <- ''

    table2.wide[78,'subitem'] <- paste(table2.wide[77:78,'item'], collapse = ' ')
    table2.wide[78,'item'] <- table2.wide[76,'item']

    table2.wide[79,'item'] <- ''

    table2.wide$footnotes <- ''

    # Remove junk.
    table2.wide <- na.omit(table2.wide)

    # Make numeric.
    table2.wide[c('today', 'mtd', 'ytd')] <- data.frame(lapply(table2.wide[c('today', 'mtd', 'ytd')], number))

    # Arrange nicely.
    table2.wide[c(
        'date', 'table', 'item', 'type', 'subitem',
        'is.total', 'today', 'mtd', 'ytd', 'footnotes'
    )]
}

table5 <- function() {
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
    table5.wide[1] <- strip(table5.wide[,1])
    table5.wide[-1] <- data.frame(lapply(table5.wide[-1], number))
    
    # Income or expense?
    table5.wide$direction <- factor(c(rep('income', 5), rep('expense', 6)))
    
    table5.long <- melt(table5.wide, c('direction', 'transaction'),
        variable.name = 'type.of.depository', value.name = 'amount')
    table5.long
}

main <- function() {
    datestamp <- commandArgs(trailingOnly = T)[1]
    write.csv(table2(datestamp),
        file = paste('archive', datestamp, 'table2.csv', sep = '/'),
        row.names = F
    )
}

main()
