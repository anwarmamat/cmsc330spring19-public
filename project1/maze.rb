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
  return opencnt
end

# sortcells prints the cells in the maze sorted by the number of openings.
# i'll have 5 strings each containing the coordinates of the cells with 
# appropriate openings. Then, ill simply concatenate them as we scan the list.
def sortcells(file)
  
  dir0 = "0"
  dir1 = "1"
  dir2 = "2"
  dir3 = "3"
  dir4 = "4"

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
      	dir4 = dir4 +",("+x+","+y+")"
      elsif ds =~/[uldr]{3}/
      	dir3 = dir3 +",("+x+","+y+")"
      elsif ds =~/[uldr]{2}/
      	dir2 = dir2 +",("+x+","+y+")"
      elsif ds =~/[uldr]/
      	dir1 = dir1 +",("+x+","+y+")"
      else
      	dir0 = dir0 +",("+x+","+y+")"
      end
    end
  end
  return [dir0, dir1, dir2, dir3, dir4]
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
  return bridgect
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

def paths(file)

  line = file.gets
  if line == nil then return end

  # read 1st line, must be maze header
  sz, sx, sy, ex, ey = line.split(/\s/)

  sz = sz.to_i
  cells = Array.new(sz)
  for i in 0..(sz-1)
    cells[i] = Array.new(sz)
  end
  
  pathlist = Hash.new

  # read additional lines
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] == "path"
      p, name, x, y, ds = line.split(/\s/)
      
      x = x.to_i
      y = y.to_i
      totalwt = 0.0
      valid = 1

      for i in 0..(ds.length-1)

      	
      	if (cells[x][y][ds[i]] == "noval")
      		valid = 0
      		break
      	else
      		totalwt = totalwt + cells[x][y][ds[i]].to_f

      		case (ds[i])
      		when "u"
      			y = y - 1
      		when "l"
      			x = x - 1
      		when "d"
      			y = y + 1
      		when "r"
      			x = x + 1
      		end

      		if (x < 0 || y < 0 || x >= sz || y >= sz)
      			valid = 0
      			break
      		end
      	end
	  end
	  if valid == 1
	  	pathlist[totalwt] = name
	  end
    # otherwise must be cell specification (since maze spec must be valid)
    else
      x, y, ds, w = line.split(/\s/,4)

      ws = w.split(/\s/)

      x = x.to_i
      y = y.to_i

      cells[x][y] = Hash.new("noval")
      # assign values to the hash in the cells
      for i in 0..(ds.length - 1)

      	cells[x][y][ds[i]] = ws[i]

      end

    end


  end
  keylist = pathlist.keys.sort
  retarr = []
  if keylist.length == 0
  	return "none"
  else
  	keylist.each{|k| retarr << sprintf("%10.4f %s", k, pathlist[k])}
  	return retarr
  end
end

# PART 3
# Pretty Printing <3 <3 <3

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
  printcells = Array.new(sz)
  for i in 0..(sz-1)
    printcells[i] = Array.new(sz, "")
  end
  pathcells = Array.new(sz)
  for i in 0..(sz-1)
    pathcells[i] = Array.new(sz)
  end 
  pathlist = Hash.new

  #add start and end tags to these cells
  printcells[sx][sy] = printcells[sx][sy] + "s"
  printcells[ex][ey] = printcells[ex][ey] + "e"

  while line = file.gets do

    # begins with  path, path processing
    if line[0...4] == "path"

   	  # cloned code from part 3, but instead of saving path name,
   	  # we save the directions and the starting cell.
      p, name, x, y, ds = line.split(/\s/)
      
      # These will mark the start of the path, "CellStart(x/y)"
      csx = x
      csy = y

      x = x.to_i
      y = y.to_i

      

      totalwt = 0.0
      valid = 1

      for i in 0..(ds.length-1)

      	
      	if (pathcells[x][y][ds[i]] == "noval")
      		valid = 0
      		break
      	else
      		totalwt = totalwt + pathcells[x][y][ds[i]].to_f

      		case (ds[i])
      		when "u"
      			y = y - 1
      		when "l"
      			x = x - 1
      		when "d"
      			y = y + 1
      		when "r"
      			x = x + 1
      		end

      		if (x < 0 || y < 0 || x >= sz || y >= sz)
      			valid = 0
      			break
      		end
      	end
	  end
	  if valid == 1
	  	pathlist[totalwt] = csx + " " + csy + " " + ds
	  end

    # otherwise must be cell specification (since maze spec must be valid)
    else
      x, y, ds, w = line.split(/\s/,4)
      
      x = x.to_i
      y = y.to_i

      ws = w.split(/\s/)

	  printcells[x][y] = printcells[x][y] + ds
      pathcells[x][y] = Hash.new("noval")
      # assign values to the hash in the cells
      for i in 0..(ds.length - 1)

      	pathcells[x][y][ds[i]] = ws[i]

      end

    end

  end
  # Path Preprocessing part 2
  # This will take the shortest path, then mark each cell which the path would take
  # up with a "p" in order to denote that it should print an asterisk in said cell.
  keylist = pathlist.keys.sort
  if keylist.length > 0

  	x, y, ds = pathlist[keylist[0]].split(/\s/)
  	x = x.to_i
  	y = y.to_i

    for i in 0..(ds.length-1)

    		printcells[x][y] = printcells[x][y] + "p"

      		case (ds[i])
      		when "u"
      			y = y - 1
      		when "l"
      			x = x - 1
      		when "d"
      			y = y + 1
      		when "r"
      			x = x + 1
      		end

      		if (x < 0 || y < 0 || x >= sz || y >= sz)
      			valid = 0
      			break
      		end

      
	end
	printcells[x][y] = printcells[x][y] + "p"

  end


  # Start actual printing

  final = ""
  # Start the maze with the corner, then iterate the -+ sequence based on size. 
  final += "+"
  for px in 0..(sz-1)
    final += "-+"
  end
  final += "\n"

  # Start iterating through the rows, column by column. 
  for py in 0..(sz-1)
    final +="|"
    for px in 0..(sz-1)

      #These conditionals 
      if printcells[px][py] =~ /p/
      	if printcells[px][py] =~ /s/
        	final += "S"
      	elsif printcells[px][py] =~ /e/
        	final += "E"
     	else
        	final += "*"
      	end
      else
      	if printcells[px][py] =~ /s/
        	final += "s"
      	elsif printcells[px][py] =~ /e/
	        final += "e"
    	else
	        final += " "
    	end
      end

      if printcells[px][py] =~ /r/
        final += " "
      else
        final += "|"
      end

    end
    #
    final += "\n+"

    for px in 0..(sz-1)

      if printcells[px][py] =~ /d/
        final += " "
      else
        final += "-"
      end

      final += "+"
    end
    if (py != sz-1)
    	final += "\n"
	end
  end
  printf("")
  return final

end

# PART 4 (and 5)
# Find Distance of Cells from the start.

# distance() will print the cells in the maze based on the distance
# they are from the start cell. The output format is similar to 
# that of the sortcells output. 

def distance(file, mode)
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

    # start doing cell processing
    if line[0...4] != "path"

      x, y, ds, w = line.split(/\s/,4)
      
      x = x.to_i
      y = y.to_i

	  cells[x][y] = cells[x][y] + ds
    end

  end

  reached = Hash.new(-1)
  distct = 0
  newcells = 1
  currcells = [(sx*sz + sy)]
  reached[(sx*sz + sy)] = 0
  nextcells = []

  while newcells == 1
  	newcells = 0

  	currcells.each do |v|

  		y = v % sz
  		x = (v - (v % sz))/sz
  		ds = cells[x][y]
  		for i in 0..(ds.length-1)
  			case ds[i]
  			when "u"
  				if(reached[v - 1] == -1)
  					nextcells << (v - 1)
  					newcells = 1
  				end
  			when "d"
				if(reached[v + 1] == -1)
  					nextcells << (v + 1)
  					newcells = 1
  				end
  			when "l"
				if(reached[v - sz] == -1)
  					nextcells << (v - sz)
  					newcells = 1
  				end
  			when "r"
				if(reached[v + sz] == -1)
  					nextcells << (v + sz)
  					newcells = 1
  				end
  			end
  		end
		reached[v] = distct
  	end
  	currcells.clear
  	nextcells.each do |v|
  		currcells << v
  	end
  	nextcells.clear
  	distct += 1
  end

  retstr = ""
  if mode =="dist"
	  distformatter = Hash.new {"error"}
	  reachkeys = reached.keys.sort
	  reachkeys.each do |k|
		y = k % sz
	  	x = (k - (k % sz))/sz

	  	if (distformatter[reached[k]] == "error")
	  		distformatter[reached[k]] = []
	  	end

	  	distformatter[reached[k]] << k

	  end

	  for i in 0..(distct-1)
	  	retstr += "#{i}"
	  	distformatter[i].sort
	  	distformatter[i].each do |k|
			y = k % sz
	  		x = (k - (k % sz))/sz
	  		retstr += ",(#{x},#{y})"
	  	end
	  	if i != (distct -1)
	  		retstr += "\n"
	  	end
	  end
	  return retstr
  elsif mode == "solve"
  	if reached[(ex*sz + ey)] == -1
  		return false
  	else
  		return true
  	end
  end

end

# Part 6

# Parsing

def parse(file)

  validity = true;
  fullfile = []
  parsedfile = []
  line = file.gets
  if line == nil then return end

  # READ THE FIRST LINE-------------------------------------------
  if line =~ /^size=(\d+) start=\((\d+),(\d+)\) end=\((\d+),(\d+)\)$/
	sz = $1
	sx = $2
	sy = $3
	ex = $4 
	ey = $5
	sz = sz.to_i
	sx = sx.to_i
	sy = sy.to_i
	ex = ex.to_i
	ey = ey.to_i
	if (sx < sz && sy < sz && ex < sz && ey < sz &&
		sx >= 0 && sy >= 0 && ex >= 0 && ey >= 0)
		fullfile << line
		parsedfile << "#{sz} #{sx} #{sy} #{ex} #{ey}"
	else
  		validity = false;
  		fullfile << "i" + line
  	end		
  else
  	validity = false;
  	fullfile << "i" + line
  end

  cells = Array.new(sz)
  for i in 0..(sz-1)
    cells[i] = Array.new(sz,"")
  end 

  # READ THE NEXT FEW LINES
  while line = file.gets do
  	linevalid = true
    # begins with "path", must be path specification
    if line[0...4] == "path"
      paths = line.split(/ /)
      paths.each do |path|

      	if path =~ /^path:"(.+)",\((\d+),(\d+)\)(,[dulr]){1,};$/
      		pname = $1
      		x = $2
      		y = $3
      		path = path.reverse!
      		path = path.split(/[,;]/)
      		i = 1
      		ds = ""
      		while path[i] =~ /[udlr]/
      			ds = path[i] + ds
      			i += 1
      		end

      		parsedfile << "path #{pname} #{x} #{y} #{ds}"
      	else
      		linevalid = false;
      	end
	  end
	  if !linevalid
      		validity = false
      		fullfile << "i" + line
      end

    # otherwise, should be a line
    else
      coords, ds, w = line.split(/ /)
      if coords =~ /^(\d+),(\d+):$/
      	x = $1
      	y = $2
      else
      	linevalid = false
      end

      if ds =~ /[udlr]{0,4}/
      	if ds =~/[^udlr]/
      		linevalid = false
      	end

      else
      	linevalid = false
      end

      ws = w.split(/[,\n]/)

      if ds.length != ws.length
      	linevalid = false
      else
      	ws.each do |s|
      	  if s =~ /^(-?\d+\.?\d+)$/

      	  else
      	  	linevalid = false
      	  end
      	end
      end

      x = x.to_i
      y = y.to_i

      cells[x][y]+=ds

      if linevalid
      	tempstr = "#{x} #{y} #{ds}"
      	ws.each do |s|
      		tempstr += " #{s}"
      	end
      	parsedfile << tempstr
      	fullfile << line
      else
      	validity = false
      	fullfile << "i" + line
	  end
    end
  end

    if validity
	  for x in 0..(sz-1)
	  	for y in 0..(sz-1)
	  		ds = cells[x][y]
	  		for i in 0..(ds.length-1)
	  			case ds[i]
	  			when "u"
	  				if(y >= 0 && cells[x][y-1] =~ /d/)
					
					else
	  					validity = false
	  					for i in 0..fullfile.length-1
	  						if fullfile[i] =~ /^#{x},#{y}/
	  							fullfile[i] = "i" + fullfile[i]
	  						end
	  						if fullfile[i] =~ /^#{x},#{y-1}/
	  							fullfile[i] = "i" + fullfile[i]
	  						end
	  					end
	  				end
	  			when "d"
					if(y < sz && cells[x][y+1] =~ /u/)
					
					else
	  					validity = false
	  					for i in 0..fullfile.length-1
	  						if fullfile[i] =~ /^#{x},#{y}/
	  							fullfile[i] = "i" + fullfile[i]
	  						end
	  						if fullfile[i] =~ /^#{x},#{y+1}/
	  							fullfile[i] = "i" + fullfile[i]
	  						end
	  					end

	  				end
	  			when "l"
					if(x >= 0 && cells[x-1][y] =~ /r/)
					
					else
	  					validity = false
	  					for i in 0..fullfile.length-1
	  						if fullfile[i] =~ /^#{x},#{y}/
	  							fullfile[i] = "i" + fullfile[i]
	  						end
	  						if fullfile[i] =~ /^#{x-1},#{y}/
	  							fullfile[i] = "i" + fullfile[i]
	  						end
	  					end
	  				end
	  			when "r"
					if(x < sz && cells[x+1][y] =~ /l/)
					
					else
	  					validity = false
	  					for i in 0..fullfile.length-1
	  						if fullfile[i] =~ /^#{x},#{y}/
	  							fullfile[i] = "i" + fullfile[i]
	  						end
	  						if fullfile[i] =~ /^#{x+1},#{y}/
	  							fullfile[i] = "i" + fullfile[i]
	  						end
	  					end
	  				end
	  			end
	  			
	  		end
	  	end
	  end
	end

  if validity
  	return parsedfile.join("\n")
  else
  	tempstr = "invalid maze"

  	fullfile.each do |s|
  		if s[0] == "i"
  			s = s[1..s.length-2]
  			tempstr += "\n" + s
  		end
  	end
  	return tempstr
  end
end

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
  	return bridge(maze_file)
  when "print"
    prettyprint(maze_file)
  when "paths"
	paths(maze_file)
  when "distance"
	return distance(maze_file, "dist")
  when "solve"
  	return distance(maze_file, "solve")
  else
    fail "Invalid command"
  end
end