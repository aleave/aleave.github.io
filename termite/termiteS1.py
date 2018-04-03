# -*- coding: utf-8 -*-
"""
Created on Mon Apr  2 22:09:09 2018

@author: AVERCHI_A
"""
import numpy as np
import matplotlib.pyplot as plt
import pdb

from pytictoc import TicToc
t = TicToc() #create instance of class


#plt.scatter(x, y, s=area, c=colors, alpha = 0.5)

posXmax = 600
posYmax = 600



tSize = 2.5

class TermiteS:
    
    def __init__(self, posX, posY):
        self.positionX = posX
        self.positionY = posY
        
        
        self.carryChip = False
        self.posXmax = posXmax
        self.posYmax = posYmax
        
          
     
        
    
    def move(self):
        
        direction = np.random.choice(["X","Y"])
        orientation = np.random.choice([-1,1])
        
        if direction == "X":
            self.positionX += orientation
        else:
            self.positionY += orientation
                       
        
        if (self.positionX > self.posXmax):
            self.positionX = 0
            
        
        if (self.positionX < 0):
            self.positionX = self.posXmax
            
            
        if (self.positionY > self.posYmax):
            self.positionY = 0
            
            
        if (self.positionY < 0):
            self.positionY = self.posYmax
            


nTermites = 1000

tGroup = []

#populate Termite list
for i in range(1,nTermites+1):
    posX = np.random.randint(0,posXmax)
    posY = np.random.randint(0,posYmax)
    tGroup.append(TermiteS(posX, posY))
    
    
nChips = 50000

chipsMat = np.zeros([posXmax+1,posYmax+1])


for i in range(1,nChips+1):
    randX = np.random.randint(0,posXmax)
    randY = np.random.randint(0,posYmax)
    chipsMat[randX,randY] += 1
 
chipsMatInit = chipsMat.copy()


plt.matshow(chipsMat, cmap="Greys",vmax=5)  

nIter = 3000

t.tic()
for n in range(0,nIter):
    
    if ( n % 100 == 0):
        print(n)
    
    for ter in tGroup:
        ter.move()
        nChipsPos = chipsMat[ter.positionX, ter.positionY]
        
        if nChipsPos > 0:
            
            if ter.carryChip:
                ter.carryChip = False
                chipsMat[ter.positionX, ter.positionY] +=1
            else:
                ter.carryChip = True
                chipsMat[ter.positionX, ter.positionY] -=1

t.toc()

plt.matshow(chipsMat, cmap="Greys", vmax=5)  
 
    
    