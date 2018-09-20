# Statistics Code for Haley, Hampton & Marder 2018
# Last Edited 08.28.18 by JAH
# ------------------------------------------------------------------
# 1. One-Way Repeated Measures ANOVA w/ Paired Samples T-Tests (Bonferroni)
# 2. Two-Way Mixed Measures ANOVA w/ Independent Samples T-Tests (Bonferroni)
# ------------------------------------------------------------------

# Clear Workspace
rm(list = ls())

# Input Directory, Filename, and Test type (1 or 2)
directory = "/Volumes/HardDrive/Haley Hampton Marder 2018/Data"
directory_out = "/Volumes/HardDrive/Haley Hampton Marder 2018/Statistics"
filename = 'PD_waveMin.csv'
test = 1 # type 1 for one-way ANOVa, 2 for two-way

# ------------------------------------------------------------------

# Load car package, set directory and filename
library(car)
setwd(directory)
data.csv = read.csv(filename)

# ------------------------------------------------------------------
# 1. One-Way Repeated Measures ANOVA (Type III) from car package
#    Paired Samples T-Tests with Bonferroni correction
#    Data must be formatted for 1 row per preparation, 1 col per condition
#    More info on this ANOVA here: http://dwoll.de/rexrepos/posts/anovaRBFpq.html

if (test==1){

# Prepare 1-Way ANOVAs
acid.lm=lm(cbind(pH55,pH61,pH67,pH72,pH78_2)~1,data=data.csv)
acid.i=expand.grid(pH=gl(5,1))
base.lm=lm(cbind(pH78_3,pH83,pH88,pH93,pH98,pH104)~1,data=data.csv)
base.i=expand.grid(pH=gl(6,1))

# Compute 1-Way ANOVAs (separate tests for acid and base)
acid.Anova=Anova(acid.lm,idata=acid.i,idesign=~pH,type="III")
a = summary(acid.Anova,multivariate=FALSE,univariate=TRUE)
base.Anova=Anova(base.lm,idata=base.i,idesign=~pH,type="III")
b = summary(base.Anova,multivariate=FALSE,univariate=TRUE)

# Produce ANOVA Output Table
one_anova = t(matrix(c(a$univariate.tests[2,c(2,4,5,6)],b$univariate.tests[2,c(2,4,5,6)]),nrow=4,ncol=2))
colnames(one_anova) <- c("df1","df2","F(pH)","p")
rownames(one_anova) <- c("acid","base")
one_anova <- as.table(one_anova)

# Compute Paired T-Tests
t_55 = t.test(data.csv$pH78_2,data.csv$pH55, paired = TRUE)
t_61 = t.test(data.csv$pH78_2,data.csv$pH61, paired = TRUE)
t_67 = t.test(data.csv$pH78_2,data.csv$pH67, paired = TRUE)
t_72 = t.test(data.csv$pH78_2,data.csv$pH72, paired = TRUE)
t_83 = t.test(data.csv$pH78_3,data.csv$pH83, paired = TRUE)
t_88 = t.test(data.csv$pH78_3,data.csv$pH88, paired = TRUE)
t_93 = t.test(data.csv$pH78_3,data.csv$pH93, paired = TRUE)
t_98 = t.test(data.csv$pH78_3,data.csv$pH98, paired = TRUE)
t_104 = t.test(data.csv$pH78_3,data.csv$pH104, paired = TRUE)

# Produce Paired T-Test Output Table
paired_t = matrix(c(t_55$statistic,t_61$statistic,t_67$statistic,t_72$statistic,t_83$statistic,
                   t_88$statistic,t_93$statistic,t_98$statistic,t_104$statistic,
                   t_55$p.value*4,t_61$p.value*4,t_67$p.value*4,t_72$p.value*4,t_83$p.value*5,
                   t_88$p.value*5,t_93$p.value*5,t_98$p.value*5,t_104$p.value*5),nrow=9,ncol=2)
colnames(paired_t) <- c("T","p")
rownames(paired_t) <- c("pH 5.5","pH 6.1","pH 6.7","pH 7.2","pH 8.3","pH 8.8","pH 9.3","pH 9.8","pH 10.4")
paired_t <- as.table(paired_t)

# Save Output Tables
write.csv(one_anova, file = paste(directory_out,"ANOVAs",filename,sep = "/"))
write.csv(paired_t, file = paste(directory_out,"T_Tests",filename,sep = "/"))

# ------------------------------------------------------------------
# 2. Two-Way Mixed Measures ANOVA (Type III) from car package
#    Independent Samples T-Tests with Bonferroni correction
#    Data must be formatted for 1 row per preparation, 1 col per condition
#    More info on this ANOVA here: http://psych.wisc.edu/moore/Rpdf/610-R11_MixedDesign.pdf

} else {

# Prepare 2-Way ANOVAs
g = factor(data.csv$Ganglion)
acid.lm=lm(cbind(pH55,pH61,pH67,pH72,pH78_2)~1,data=data.csv)
acid.i=expand.grid(pH=gl(5,1))
base.lm=lm(cbind(pH78_3,pH83,pH88,pH93,pH98,pH104)~1,data=data.csv)
base.i=expand.grid(pH=gl(6,1))

# Compute 2-Way ANOVAs
acid.Anova=Anova(acid.lm,idata=acid.i,idesign=~pH,type="III")
a = summary(acid.Anova,multivariate=FALSE,univariate=TRUE)
base.Anova=Anova(base.lm,idata=base.i,idesign=~pH,type="III")
b = summary(base.Anova,multivariate=FALSE,univariate=TRUE)

# Produce ANOVA Output Table
two_anova = t(matrix(c(a$univariate.tests[2,c(2,4,5,6)],a$univariate.tests[3,c(2,4,5,6)],a$univariate.tests[4,c(2,4,5,6)],
                       b$univariate.tests[2,c(2,4,5,6)],b$univariate.tests[3,c(2,4,5,6)],b$univariate.tests[4,c(2,4,5,6)]),
                     nrow=4,ncol=6))
colnames(two_anova) <- c("df1","df2","F","p")
rownames(two_anova) <- c("acid:ganglion","acid:pH","acid:ganglion*pH","base:ganglion","base:pH","base:ganglion*pH")
two_anova <- as.table(two_anova)

# Independent Samples T-tests
t_55 = t.test(data.csv$pH55~g)
t_61 = t.test(data.csv$pH61~g)
t_67 = tryCatch(t.test(data.csv$pH67~g),error=function(cond)
  list("statistic" = NA,p.value = NA))
t_72 = tryCatch(t.test(data.csv$pH72~g),error=function(cond)
  list("statistic" = NA,p.value = NA))
t_83 = t.test(data.csv$pH83~g)
t_88 = t.test(data.csv$pH88~g)
t_93 = t.test(data.csv$pH93~g)
t_98 = t.test(data.csv$pH98~g)
t_104 = t.test(data.csv$pH104~g)

# Produce Independent T-Test Output Table
independent_t = matrix(c(t_55$statistic,t_61$statistic,t_67$statistic,t_72$statistic,t_83$statistic,
                    t_88$statistic,t_93$statistic,t_98$statistic,t_104$statistic,
                    t_55$p.value*4,t_61$p.value*4,t_67$p.value*4,t_72$p.value*4,t_83$p.value*5,
                    t_88$p.value*5,t_93$p.value*5,t_98$p.value*5,t_104$p.value*5),nrow=9,ncol=2)
colnames(independent_t) <- c("T","p")
rownames(independent_t) <- c("pH 5.5","pH 6.1","pH 6.7","pH 7.2","pH 8.3","pH 8.8","pH 9.3","pH 9.8","pH 10.4")
independent_t <- as.table(independent_t)

# Save Output Tables
write.csv(two_anova, file = paste(directory_out,"ANOVAs",filename,sep = "/"))
write.csv(independent_t, file = paste(directory_out,"T_Tests",filename,sep = "/"))
}