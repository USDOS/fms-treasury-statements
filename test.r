library(testthat)

# This test runner assumes that the parser has already run.
test.runner <- function(datestamp, filename, sql){
  table <- read.csv(paste('archive', datestamp, filename, sep = '/'))
  observed <- sqldf(sql)

  table <- read.csv(paste('test', datestamp, filename, sep = '/'))
  expected <- sqldf(sql)

  expect_equal(observed, expected)
}

# Vectors of SQL so we can pinpoint errors.
sql <- c(
  'SELECT count(*) FROM table',
  'SELECT * FROM table'
)

test.runner('2012-11-29', 'table1.csv', sql)
test.runner('2012-11-29', 'table2.csv', sql)
test.runner('2012-11-29', 'table3a.csv', sql)
test.runner('2012-11-29', 'table3b.csv', sql)
test.runner('2012-11-29', 'table3c.csv', sql)
test.runner('2012-11-29', 'table4.csv', sql)
test.runner('2012-11-29', 'table5.csv', sql)
test.runner('2012-11-29', 'table6.csv', sql)
