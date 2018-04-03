using PyPlot

posXmax = 100
posYmax = 100

mutable struct TermiteS
    positionX::Int64
    positionY::Int64
    carryChip::Bool
end

TermiteS(positionX,positionY) = TermiteS(positionX, positionY, false)


function move(t::TermiteS)
    direction = rand(["X", "Y"])
    orientation = rand([-1,1])

    if direction == "X"
        t.positionX += orientation
    else
        t.positionY += orientation
    end

    if t.positionX > posXmax
        t.positionX = 1
    end

    if t.positionX < 1
        t.positionX = posXmax
    end

    if t.positionY > posYmax
        t.positionY = 1
    end

    if t.positionY < 1
        t.positionY = posYmax
    end

end

nTermites = 1000

tGroup = Array{TermiteS}(nTermites)

for i = 1:nTermites
    tGroup[i] = TermiteS(rand(1:posXmax),rand(1:posYmax))
end

nChips = 2000

chipsMat = zeros(Int64, posXmax, posYmax)

for i in 1:nChips
    chipsMat[rand(1:posXmax),rand(1:posYmax)] +=1
end

matshow(chipsMat, cmap="Greys", vmax =5)

nIter = 10000000

tic()

for n in 1:nIter
    if n % 10000 == 0
        println(n)
    end

    for ter in tGroup
        move(ter)
        nChipsPos = chipsMat[ter.positionX, ter.positionY]

        if nChipsPos > 0

            if ter.carryChip
                ter.carryChip = false
                chipsMat[ter.positionX, ter.positionY] +=1
            else
                ter.carryChip = true
                chipsMat[ter.positionX, ter.positionY] -=1
            end

        end
    end

end

toc()

matshow(chipsMat, cmap="Greys", vmax =5)
