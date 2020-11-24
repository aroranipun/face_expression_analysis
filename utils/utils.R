len_unique <- function(x) {
  #Length of unique elements in a vector
  return(length(unique(x)))
}

len_which <- function(x) {
  #Length of conditionally satisfied vector
  return (length(which(x)))
}
angle <- function(a, b) {
  a = a / sqrt(sum(a^2))
  b = b / sqrt(sum(b^2))
  theta <- acos(sum(a * b) / (sqrt(sum(a * a)) * sqrt(sum(b * b))))
  return(theta)
}