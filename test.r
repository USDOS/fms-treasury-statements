library(testthat)
source('parse.r')

# Vectors of SQL
test.sql <- c(
  'SELECT count(*) FROM table1',
)


test.runner <- function(datestamp){
  .read.csv <- function(filename) {
    read.csv(paste(datestamp, filename, sep = '/'))
  }
  table1  <- .read.csv('table1.csv')
  table2  <- .read.csv('table2.csv')
  table3a <- .read.csv('table3a.csv')
  table3b <- .read.csv('table3a.csv')
  table3c <- .read.csv('table3a.csv')
  table4  <- .read.csv('table4.csv')
  table5  <- .read.csv('table5.csv')
  table6  <- .read.csv('table6.csv')


1. Someone(s) manually converts one source file to eight csv files
    (one per table).
2. Someone (probably me) writes code to load those csv files into a sqlite
    database. This is really simple; it's just the schema and
    some flags for the sqlite3 command.
    3. Someone (probably me) writes code to run SQL on two different
        databases and compare the result.
    4. Someone writes tests using the above SQL thingy. Write SQL
        queries to be run on the dataset for one table or one day. The
        result should be the same regardless of whether we run them on
            the manually parsed data or the automatically parsed data.
