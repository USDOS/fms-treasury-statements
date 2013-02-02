#!/usr/bin/env Rscript
library(testthat)

# This test runner assumes that the parser has already run.
test.runner <- function(datestamp, filename, sql){
  observed <- read.csv(paste('archive', datestamp, filename, sep = '/'), stringsAsFactors = F)
  expected <- read.csv(paste('fixtures', datestamp, filename, sep = '/'), stringsAsFactors = F)

  print(observed[1:2,])
  print(expected[1:2,])
  expect_equal(colnames(observed), colnames(expected))
  expect_equal(ncol(observed), ncol(expected))
  expect_equal(nrow(observed), nrow(expected))
  for (colname in colnames(expected)){
    if (sum(observed[,colname] != expected[,colname]) > 0) {
        df = data.frame(
            observed = (observed[,colname]),
            expected = (expected[,colname]),
            stringsAsFactors = F
        )
        print(df[df$observed != df$expected,])
    }
    expect_equal(observed[,colname], expected[,colname], info = paste('failed on', colname, 'column'))
  }
}

#test.runner('20121129', 'table1.csv')
test.runner('20121129', 'table2.csv')
#test.runner('20121129', 'table3a.csv')
#test.runner('20121129', 'table3b.csv')
#test.runner('20121129', 'table3c.csv')
#test.runner('20121129', 'table4.csv')
#test.runner('20121129', 'table5.csv')
#test.runner('20121129', 'table6.csv')
