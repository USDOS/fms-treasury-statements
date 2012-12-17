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
table1.sql <- c(
  'SELECT count(*) FROM table',
  'SELECT * FROM table'
)

test.runner('2012-11-29', 'table1.csv', table1.sql)
