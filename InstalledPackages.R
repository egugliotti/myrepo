# To get a csv of installed packages
installed <- as.data.frame(installed.packages())
write.csv(installed, "/Users/elizabethgugliotti/Desktop/EORES v1.6 Files (PROD-NOSIA-II)/Output/installed_previously.csv")

# To retrieve that csv of installed packages and load them into R if there is ever a reboot
installedPreviously <-read.csv("/Users/elizabethgugliotti/Desktop/EORES v1.6 Files (PROD-NOSIA-II)/Output/installed_previously.csv")
baseR <- as.data.frame(installed.packages())
toInstall <- setdiff(installedPreviously, baseR)

install.packages(toInstall$Package)
