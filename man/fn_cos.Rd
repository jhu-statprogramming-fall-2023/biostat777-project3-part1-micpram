% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{fn_cos}
\alias{fn_cos}
\title{Compute cosine using truncated series expansion}
\usage{
fn_cos(x, k)
}
\arguments{
\item{x}{The number for cosine computation}

\item{k}{Number of terms beyond the constant 1 in the series expansion}
}
\value{
The computed cosine value
}
\description{
Compute cosine using truncated series expansion
}
\examples{
fn_cos(x=0.5, k=10)
}
