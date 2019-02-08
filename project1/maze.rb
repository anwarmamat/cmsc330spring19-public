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
#
#
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

  puts "#{opencnt}"
end




#----------------------------------
def main(command_name, file_name)
  maze_file = open(file_name)

  # perform command
  case command_name
  when "parse"
    parse(maze_file)
  when "print"
    read_and_print_simple_file(maze_file)
  when "open"
  	openct(maze_file)
  else
    fail "Invalid command"
  end
end



