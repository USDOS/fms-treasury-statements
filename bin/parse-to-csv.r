library(reshape2)
library(stringr)

strip <- function(string) {
    # Strip leading and trailing spaces
    str_replace(str_replace(string, '^ *', ''), ' *$', '')
}

number <- function(string){
    # Remove the leading dollar sign, remove commas, and convert to numeric.
    as.numeric(str_replace_all(str_replace(strip(string), '^[$]?', ''), ',', ''))
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


# Date,Table,Account,Item,Type,Subtype,Today,MTD,FYT,Footnotes
# 11/29/2012,2,Federal Reserve Account,Agriculture Loan Repayments (misc),Deposits,,27,472,"1,296",

table2 <- function() {
    # Load file
    table2.wide <- read.fwf(
        'archive/20121129/table2.fixie',
        c(51, 13, 1, 13, 1, 13),
        stringsAsFactors = F
    )[,-c(3, 5)]
    colnames(table2.wide) <- c('account', 'today', 'this.month', 'this.fiscal.year')
    table2.wide[2, 1] <- paste(strip(table2.wide[2:3, 1]), collapse = ' ')
    table2.wide <- table2.wide[-3,]

    table2.wide[1] <- strip(table2.wide[,1])
    table2.wide[-1] <- data.frame(lapply(table2.wide[-1], number))

    table2.wide
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