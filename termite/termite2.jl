using PyPlot

posXmax = 600.0
posYmax = 600.0

tSize = 2.5
cRadius = 1

mutable struct Position
    x::Float64
    y::Float64
end

mutable struct BoundingBox
    left::Float64
    right::Float64
    top::Float64
    bottom::Float64
end

BoundingBox(pos::Position, size::Float64) = BoundingBox(pos.x-size, pos.x+size, pos.y + size, pos.y-size)

mutable struct Chip
    pos::Position
    color::String
    radius::Float64
    plotArea::Float64
    onTermite::Bool

end

Chip(pos::Position) = Chip(pos, "#FF533D", cRadius, pi * cRadius ^ 2, false)


mutable struct ChipCarrier
    color::String
    hasChip::Bool
    chip::Nullable{Chip}

end

ChipCarrier() = ChipCarrier("#1A2930", false, Nullable{Chip}())

struct Termite
    pos::Position
    bounds::BoundingBox
    carriesChip::ChipCarrier
    plotArea::Float64
end

Termite(pos::Position) = Termite(pos,
                    BoundingBox(pos,tSize),
                    ChipCarrier(),
                    pi * tSize ^ 2
                    )



function updateBoundingBox(t::Termite)
    t.bounds.left = t.pos.x - tSize;
    t.bounds.right = t.pos.x + tSize;
    t.bounds.bottom = t.pos.y - tSize;
    t.bounds.top = t.pos.y + tSize;

end

move = function(t::Termite, speedX::Float64, speedY::Float64)
    t.pos.x += (2 * rand() - 1) * speedX;
    t.pos.y += (2 * rand() - 1) * speedY;
    updateBoundingBox(t)

    if (t.bounds.left > posXmax)
        t.pos.x = 0
        updateBoundingBox(t)
    end

    if (t.bounds.right < 0)
        t.pos.x = posXmax
        updateBoundingBox(t)
    end

    if (t.bounds.bottom > posYmax)
        t.pos.y = 0
        updateBoundingBox(t)
    end

    if (t.bounds.top < 0)
        t.pos.y = posYmax
        updateBoundingBox(t)
    end
end

function scatterPlot(tGroup, wGroup)

    cposX = [ce.pos.x for ce in wGroup]
    cposY = [ce.pos.y for ce in wGroup]
    cColor = [ce.color for ce in wGroup]
    cArea = [ce.plotArea for ce in wGroup]

    tposX = [te.pos.x for te in tGroup]
    tposY = [te.pos.y for te in tGroup]
    tColor = [te.carriesChip.color for te in tGroup]
    tArea = [te.plotArea for te in tGroup]

    AposX = vcat(cposX, tposX)
    AposY = vcat(cposY,tposY)
    AColor = vcat(cColor, tColor)
    AArea = vcat(cArea, tArea)

    fig = figure(facecolor="#F5F5F5")
    axis([0,posXmax, 0, posYmax])
    scatter(AposX, AposY, AArea, AColor)

    axis("off")
    show()
    #savefig("termite.png", facecolor="#F5F5F5", edgecolor="none", bbox_inches="tight", pad_inches=0)
end

#t = Termite(Position(3.0,3.0))

nTermites = 1;

tGroup = Array{Termite}(nTermites);

for i=1:nTermites
    #add termite to array
    tGroup[i] = Termite(Position(posXmax * rand(), posYmax * rand()))
end

nChips = 200;

wGroup = Array{Chip}(nChips);
#wGroup = (Chip)[];
#now the pain: plotting
for i=1:nChips
    wGroup[i] = Chip(Position(posXmax * rand(), posYmax * rand()))
#    push!(wGroup, Chip(Position(posXmax * rand(), posYmax * rand())));
end

scatterPlot(tGroup, wGroup)

nIter = 100

speedX = 6.0
speedY = 6.0

tic()

for n in 1:nIter
    if (n % 100 == 0)
        println(n)
    end
    for i in 1:nTermites
        vAnt = tGroup[i]
        move(vAnt, speedX, speedY)
        #println(length(wGroup))
        for j in 1:length(wGroup)
            wc = wGroup[j]

            if wc.onTermite
                continue
            end
            #wc = wGroup[j]
            dist2X = (vAnt.pos.x - wc.pos.x) ^ 2
            dist2Y = (vAnt.pos.y - wc.pos.y) ^ 2

            if (dist2X + dist2Y <= tSize ^2)

                if (vAnt.carriesChip.hasChip)
                    #drop the chip to current position

                    wp = get(vAnt.carriesChip.chip)
                    print(vAnt.carriesChip.hasChip)
                    wp.pos = Position(vAnt.pos.x, vAnt.pos.y)

                    vAnt.carriesChip.hasChip = false
                    vAnt.carriesChip.color = "#1A2930"

                    vAnt.carriesChip.chip = Nullable{Chip}()

                    #Chip stops following the termite
                    #wc.pos = Position(vAnt.pos.x, vAnt.pos.y)
                    #wc.onTermite = false
                    vAnt.pos.x += 10 * rand() -5
                    vAnt.pos.y += 10 * rand() -5
                    #push!(wGroup, Chip(Position(vAnt.pos.x, vAnt.pos.y)))

                else
                    vAnt.carriesChip.hasChip = true
                    vAnt.carriesChip.color = "green"
                    wc.pos = vAnt.pos #chip starts following the termite
                    wc.onTermite = true
                    #filter!(x -> x!= wc, wGroup)
                    #println(length(wGroup))

                end

                break

            end

        end
    end
end

toc()

scatterPlot(tGroup, wGroup)
