

x <- NULL
for (i in 1:5) {
  x[i] <- paste("slave", i, sep="")
}
cat("x: ", x)

foo <- NULL
sapply(1:6, function(x) { foo[x] <<- paste("slave", i, sep="") })
foo

