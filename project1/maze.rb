# ########################################
# CMSC330---SPRING2019---PROJECT1
# Jeremy Ryan Jubilee
# UID: 115265660
# ########################################
#----------------------------------------------------------------------------
# the following is a parser that reads in a simpler version
# of the maze files.  Use it to get started writing the rest
# of the assignment.  You can feel free to move or modify 
# this function however you like in working on your assignment.

def read_and_print_simple_file(file)
  line = file.gets
  if line == nil then return end

  # read 1st line, must be maze header
  sz, sx, sy, ex, ey = line.split(/\s/)
  puts "header spec: size=#{sz}, start=(#{sx},#{sy}), end=(#{ex},#{ey})"

  # read additional lines
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] == "path"
      p, name, x, y, ds = line.split(/\s/)
      puts "path spec: #{name} starts at (#{x},#{y}) with dirs #{ds}"

    # otherwise must be cell specification (since maze spec must be valid)
    else
      x, y, ds, w = line.split(/\s/,4)
      puts "cell spec: coordinates (#{x},#{y}) with dirs #{ds}"
      ws = w.split(/\s/)
      ws.each {|w| puts "  weight #{w}"}
    end
  end
end
#
#
# This method pretty prints the maze. To do this, I will have 2 dummy
# variables, xcount and ycount, which track the current cell being 
# processed for printing. 
#Test
def prettyprint(file)

  # read the header line. split it, then extract necessary variables.
  line = file.gets
  sz, sx, sy, ex, ey = line.split(/\s/)
  
  # setup necessary vars
  sz = sz.to_i
  sx = sx.to_i
  sy = sy.to_i
  ex = ex.to_i
  ey = ey.to_i
  cells = Array.new(sz)
  for i in 0..(sz-1)
    cells[i] = Array.new(sz, "")
  end

  #add start and end tags to these cells
  cells[sx][sy] = cells[sx][sy] + "s"
  cells[ex][ey] = cells[ex][ey] + "e"

  while line = file.gets do

    # begins with  path, path processing
    if line[0...4] == "path"
      # TO IMPLEMENT LATER

    # otherwise must be cell specification (since maze spec must be valid)
    else
      x, y, ds, w = line.split(/\s/,4)
      
      x = x.to_i
      y = y.to_i
      w = w.to_i

      cells[x][y] = cells[x][y] + ds

      end
  end
  # start printing

  printf ("+")

  for px in 0..(sz-1)
    printf("-+")
  end
  printf ("\n")

  for py in 0..(sz-1)
    printf ("|")
    for px in 0..(sz-1)

      if cells[px][py] =~ /s/
        printf ("s")
      elsif cells[px][py] =~ /e/
        printf ("e")
      else
        printf (" ")
      end

      if cells[px][py] =~ /r/
        printf (" ")
      else
        printf ("|")
      end

    end
    #
    printf ("\n+")

    for px in 0..(sz-1)

      if cells[px][py] =~ /d/
        printf (" ")
      else
        printf ("-")
      end

      printf("+")
    end
    printf ("\n")
  end
  printf("")

end
#----------------------------------
# Begin my functions

#----------------------------------
# Function: open(file)
# open() simply lists the number of cells wherein all directions are open.

def openct(file)
  
  # do this to ignore first line (header)
  line = file.gets
  
  # tracks no. of "open" cells
  opencnt = 0

  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] != "path"

    	# looks for udlr in any order, 4 in a row to indicate all directions.
    	# since we assume file is valid, this will work 
    	if line =~ /[udlr]{4}/
      		opencnt += 1
      	end
    end
  end
  puts opencnt
end

# sortcells prints the cells in the maze sorted by the number of openings.
# i'll have 5 strings each containing the coordinates of the cells with 
# appropriate openings. Then, ill simply concatenate them as we scan the list.
def sortcells(file)
  
  dir0 = "0,"
  dir1 = "1,"
  dir2 = "2,"
  dir3 = "3,"
  dir4 = "4,"

  #ignore the header file
  line = file.gets
  if line == nil then return end
  # read additional lines
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] != "path"
      x, y, ds, w = line.split(/\s/,4)
      
      # This checks the no. of directions open.
      if ds =~/[uldr]{4}/
      	dir4 = dir4 +"("+x+","+y+")"
      elsif ds =~/[uldr]{3}/
      	dir3 = dir3 +"("+x+","+y+")"
      elsif ds =~/[uldr]{2}/
      	dir2 = dir2 +"("+x+","+y+")"
      elsif ds =~/[uldr]/
      	dir1 = dir1 +"("+x+","+y+")"
      else
      	dir0 = dir0 +"("+x+","+y+")"
      end
    end
  end
  puts dir0
  puts dir1
  puts dir2
  puts dir3
  puts dir4
end 

# bridge calcuates the number of bridges present in the maze.
# to do this, i will have two counters, wherein one calculates 
# the number of adjacent vertical cells with openings, and one
# which tracks the horizontal openings. The latter will have to
# be an array, as the way the file is formatted forces us to do so.
# since bridges can overlap, we simply reset the counter if there is no 
# opening, and increment bridgect whenever we have an appropriate number on the counter.
def bridge(file)
  line = file.gets
  if line == nil then return end

  # read 1st line, must be maze header
  sz, sx, sy, ex, ey = line.split(/\s/)

  bridgect = 0
  vertadjct = 0
  sz = sz.to_i
  horzary = Array.new(sz, 0)
  colprev = 0;
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] != "path"
      x, y, ds, w = line.split(/\s/,4)
      x =x.to_i
      
      if colprev != x
      	colprev = x
      	vertadjct = 0
      end

      if ds =~ /d/
      	vertadjct += 1
      else
      	vertadjct = 0
      end

      if ds =~ /r/
      	horzary[x] += 1
      else
      	horzary[x]=0
      end

      if vertadjct >= 2
      	bridgect+=1
      end

      if horzary[x] >=2
      	bridgect += 1
      end

    end

  end
  puts bridgect
end

# PART 2 
# Path Processing

# paths() will print all valid paths in ascending order based on
# their weight. in the case that there are no valid paths, none will
# simply be printed. 

# to do this, i will process the paths, then store the weight and name
# in a hash. Their weight will be the key, with the name being the value. 
# Then, i will simply get the array of keys, sort them by weight, and then
# iterate through the hash based on the sorted key array in order to output
# them by weight. 

# to process the paths, i will iterate through the file in order to get all the
# cell data, then go through each path. to store the data 




# PART 4 
# Find Distance of Cells from the start.

# distance() will print the cells in the maze based on the distance
# they are from the start cell. The output format is similar to 
# that of the sortcells output. 



#----------------------------------
def main(command_name, file_name)
  maze_file = open(file_name)

  # perform command
  case command_name
  when "parse"
    parse(maze_file)
  when "parseprint"
    read_and_print_simple_file(maze_file)
  when "open"
  	openct(maze_file)
  when "sortcells"
  	sortcells(maze_file)
  when "bridge"
  	bridge(maze_file)
  when "print"
    prettyprint(maze_file)
  else
    fail "Invalid command"
  end
end