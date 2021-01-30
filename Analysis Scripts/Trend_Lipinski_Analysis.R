#Descriptor Trend Analysis and Lipinski Analysis R Script
#Rac Mukkamala

library(ggplot2)
library(gridExtra)
library(dplyr)
qsar <- read.csv("Benzimidazole_SAR_Library.csv", header=TRUE)
oldPAR <- par()

#--------------Plot Generation-----------------------------------

#creating a theme function
common_theme <- function() {
  theme_classic() + 
  theme(plot.title=element_text(size=14, lineheight=0.8, hjust=0.5))
}

#generating scatterplots for logP, molecular weight, rotatable bonds
molwt <- ggplot(data=qsar, aes(x=MolWt, y=DockScore)) +
          geom_point(color="navy") +
          geom_smooth(method = "loess", color = "red", formula = y~x) +
          annotate(x=400, y=-6, 
            label=paste("R^2 == ", round(cor(qsar$MolWt, qsar$DockScore)^2,3)), 
            geom="text", size=5, parse=TRUE) +
          labs(x="Molecular Weight (Daltons)", y="Binding Affinity (kcal/mol)") +
          ggtitle("(a)") +
          common_theme()

logp <- ggplot(data=qsar, aes(x=logP, y=DockScore)) +
        geom_point(color="navy") +
        geom_smooth(method = "loess", color = "red", formula = y~x) +
        annotate(x=5.5, y=-6.5, 
                 label=paste("R^2 == ", round(cor(qsar$logP, qsar$DockScore)^2,3)), 
                 geom="text", size=5, parse=TRUE) +
        labs(x="logP", y="Binding Affinity (kcal/mol)") +
        ggtitle("(b)") +
        common_theme()

rot <- ggplot(data=qsar, aes(x=NumRotBonds, y=DockScore, group=NumRotBonds)) +
        geom_boxplot(fill="blue", color="black") +
        geom_smooth(method = "loess", color = "red", group=1) +
        annotate(x=5.5, y=-6.5, 
                 label=paste("R^2 == ", round(cor(qsar$NumRotBonds, qsar$DockScore)^2,3)), 
                 geom="text", size=5, parse=TRUE) +
        labs(x="Number of Rotatable Bonds", y="Binding Affinity (kcal/mol)") +
        ggtitle("(c)") +
        common_theme()

trend <- ggplot(data=qsar, aes(x=MolWt, y=NumRotBonds, group=NumRotBonds)) +
          geom_boxplot(fill="blue", color="black") +
          geom_smooth(method = "loess", color = "red", group=1) +
          annotate(x=300, y=10, 
                   label=paste("R^2 == ", round(cor(qsar$MolWt, qsar$NumRotBonds)^2,3)), 
                   geom="text", size=5, parse=TRUE) +
          labs(x="Molecular Weight (Daltons)", y="Number of Rotatable Bonds") +
          ggtitle("(d)") +
          common_theme()

grid.arrange(molwt, logp, rot, trend, ncol = 2)

#generate binding score distribution
ggplot(data=qsar, aes(x=DockScore)) +
        geom_histogram(fill="blue", color="black") +
        labs(x="Binding Affinity (kcal/mol)", y="Frequency") +
        ggtitle("Distribution of Binding Affinities") +
        common_theme()

#--------------------Compilation of Lipinski-Positive Analogs-----------------
lipinski <- qsar %>% 
  filter(
    NumHBD <= 5 &
      NumHBA <= 10 &
      MolWt < 500 &
      logP <= 5
  ) %>%
  select(Series, SMILES, DockScore, 
         MolWt, logP, NumHBD, NumHBA)

write.csv(lipinski, "Lipinski_Cleared.csv", row.names = FALSE)