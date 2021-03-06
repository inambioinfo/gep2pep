% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gep2pep.R
\name{PathSEA}
\alias{PathSEA}
\title{Performs Pathway Set Enrichment Analysis (PSEA)}
\usage{
PathSEA(rp_peps, pathways, bgsets = "all", collections = "all",
  details = TRUE)
}
\arguments{
\item{rp_peps}{A repository created with
\code{\link{createRepository}}, and containing PEPs created
with \code{\link{buildPEPs}}.}

\item{pathways}{A database of pathways in the same format as input
to \code{\link{createRepository}}. PSEA will be performed for
each database separately.}

\item{bgsets}{Another list like \code{pathways}, representing the
statistical background for each database. If set to "all" (the
default), all pathways that are in the repository and not in
\code{pathways} will be used.}

\item{collections}{A subset of the collection names returned by
\code{getCollections}. If set to "all" (default), all the
collections in \code{rp} will be used.}

\item{details}{If TRUE (default) details will be reported for each
condition in \code{pgset}.}
}
\value{
A list of 2, by names "PathSEA" and "details". The
    "PathSEA" entry is a 2-columns matrix including ESs and
    p-values for each collection and condition. The "details"
    entry reports the rank of each pathway in \code{pathways} for
    each condition.
}
\description{
PathSEA is analogous to the Gene Set Enrichment Analysis (GSEA),
but for pathways instead of single genes. It can therefore be used
to look for conditions under which a given set of pathways is
consistently UP- or DOWN-regulated.
}
\details{
For each condition, all pathways are ranked by how much
    they are dysregulated by it (from the most UP-regulated to the
    most DOWN-regulatied, according to the corresponding
    p-values). Then, a Kolmogorov-Smirnov (KS) test is performed to
    compare the ranks assigned to pathways in \code{pathways}
    against the ranks assigned to pathways in \code{bgsets}. A
    positive (negative) Enrichment Score (ES) of the KS test
    indicates whether each pathway is UP- (DOWN-) regulated by
    \code{pgset} as compared to \code{bgset}. A p-value is
    associated to the ES.

    When PEPs are obtained from drug-induced gene expression
    profiles, \code{PathSEA} can be used together with
    \code{gene2pathways} to perform gene2drug [1] analysis, which
    predicts which drugs may target a gene of interest (or mimick
    such effect).
}
\examples{
library(GSEABase)

db <- loadSamplePWS()
db <- as.CategorizedCollection(db)
repo_path <- file.path(tempdir(), "gep2pepTemp")

rp <- createRepository(repo_path, db)
geps <- loadSampleGEP()
buildPEPs(rp, geps)

pathways <- c("M11607", "M10817", "M16694",         ## from c3_TFT
              "M19723", "M5038", "M13419", "M1094") ## from c4_CGN
w <- sapply(db, setIdentifier) \%in\% pathways

psea <- PathSEA(rp, db[w])
## [15:35:29] Working on collection: c3_TFT
## [15:35:29] Common pathway sets removed from bgset.
## [15:35:29] Column-ranking collection...
## [15:35:29] Computing enrichments...
## [15:35:29] done.
## [15:35:29] Working on collection: C4_CGN
## [15:35:29] Common pathway sets removed from bgset.
## [15:35:29] Column-ranking collection...
## [15:35:29] Computing enrichments...
## [15:35:29] done.

getResults(psea, "c3_TFT")
##                         ES        PV
## (_)_mk_801       0.7142857 0.1666667
## (_)_atenolol     0.7142857 0.1666667
## (+)_isoprenaline 0.5714286 0.4000000
## (+/_)_catechin   0.5714286 0.4000000
## (+)_chelidonine  0.3333333 0.9333333

unlink(repo_path, TRUE)

}
\references{
[1] Napolitano F. et al, gene2drug: a Computational
    Tool for Pathway-based Rational Drug Repositioning, bioRxiv
    (2017) 192005; doi: https://doi.org/10.1101/192005
}
\seealso{
getResults, getDetails
}
