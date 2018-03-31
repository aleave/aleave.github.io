# -*- coding: utf-8 -*-
"""
Éditeur de Spyder

Ceci est un script temporaire.
"""
import numpy as np
import matplotlib.pyplot as plt

#plt.scatter(x, y, s=area, c=colors, alpha = 0.5)

posXmax = 600
posYmax = 600


tSize = 2.5

class Termite:
    
    def __init__(self, posX, posY, posXmax, posYmax, tSize):
        self.positionX = posX
        self.positionY = posY
        self.tSize = tSize
        self.color = "black"
        self.carryChip = 0
        self.posXmax = posXmax
        self.posYmax = posYmax
        self.boundsLeft = self.positionX - 1*self.tSize
        self.boundsRight = self.positionX + 1*self.tSize
        self.boundsBottom = self.positionY - 1*self.tSize
        self.boundsTop = self.positionY + 1*self.tSize
        self.plotArea = np.pi * self.tSize ** 2
          
    def move(self, speedX, speedY):
        self.positionX += (np.random.random() * 2 - 1) * speedX
        self.positionY += (np.random.random() * 2 - 1) * speedY
        
        if (self.boundsLeft > self.posXmax):
            self.positionX = 0
        
        if (self.boundsRight < 0):
            self.positionX = self.posXmax
            
        if (self.boundsTop > self.posYmax):
            self.positionY = 0
            
        if (self.boundsBottom < 0):
            self.positionY = self.posYmax
            
    def changeColor(self):
        
        if (self.color == "black"):
            self.color == "green"
        else:
            self.color = "black"


class chip:
    
    def __init__(self,xpos, ypos, radius):
        self.radius = radius
        self.color = "#FF533D"
        self.positionX = xpos
        self.positionY = ypos
        self.plotArea = np.pi * self.radius ** 2


def scatterPlot(tGroup, wGroup):    
    tposX = [termite.positionX for termite in tGroup]
    tposY = [termite.positionY for termite in tGroup]    
    tColor = [termite.color for termite in tGroup] 
    tArea =  [termite.plotArea for termite in tGroup]    

    cposX = [c.positionX for c in wGroup]
    cposY = [c.positionY for c in wGroup]    
    cColor = [c.color for c in wGroup] 
    cArea =  [c.plotArea for c in wGroup] 

    AposX = cposX + tposX
    AposY = cposY + tposY
    AColor = cColor + tColor
    AArea = cArea + tArea

    fig = plt.figure(facecolor = "#F5F5F5")

    ax=fig.add_axes([0,0,1,1])
    ax.set_axis_off()                 
    ax.scatter(AposX, AposY, AArea, AColor)
    #plt.axis("off")
    ax.set_xlim([0,posXmax])
    ax.set_ylim([0,posYmax])

    ax.set_aspect('auto')
    plt.show()
    

nTermites = 100

tGroup = []

#populate Termite list
for i in range(1,nTermites+1):
    posX = np.random.random() * posXmax
    posY = np.random.random() * posYmax
    tGroup.append(Termite(posX, posY, posXmax, posYmax, tSize))

#populate Wood chips list

nChips = 2000

cRadius = 1
wGroup = []

for j in range(1, nChips+1):
    
    wGroup.append(chip(np.random.random() * posXmax,np.random.random() * posYmax,cRadius))


scatterPlot(tGroup, wGroup)


nIter = 500

for n in range(1,nIter+1):
    for i in range(0,nTermites):
        vAnt = tGroup[i]
        
    