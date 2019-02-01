class Functions

	# Write a method shift_letters that accepts a character array
	#  and returns a new character array where each letter is increased by 1
	# E.g. shift_letters(['a','b','c','y']) should return ['b','c','d','z']
	def shift_letters(ch_arr) 
	    shifted = []

	    for i in (0...ch_arr.length-1) do
	    	# you could have used .methods or Ruby docs online
	    	# to find relevant array and character methods
	        shifted << (ch_arr[i].ord + 1).chr
	    end

	    # Notice absence of return keyword. Ruby doesn't require it.
	    # But it is generally good practice to use it.
	    # Seriously. Always use it.
	    shifted
	end


	# Write a method add_to_inventory that takes a hash new_items
	#  and a hash old_items, adds new_items to old_items, and
	#  returns the updated old_inventory
	# E.g. add_to_inventory({"avocado"=>2, "apple"=>5}, {"avocado"=>10, "tide pod"=>2})
	#  should return {"avocado"=>12, "apple"=>5, "tide pod"=>2}
	def add_to_inventory(new_items, old_items)

		for k,v in new_items do
			if old_items.has_key? k
				old_items[k] += v
				# SO much cleaner than Java
				# oldItems.put(k, oldItems.get(k) + 1)..... <-- ew
			else
				old_items[k] = v
			end
		end

		return old_items
	end

end



# Write a class WordCount. The constructor takes a String named sentence.
# Write a method getWordCount that returns a hash mapping each word to how many times it appears.
# Write a static method getHistory that returns an array of all the sentences the WordCount class has ever gotten.
# E.g. wc1 = WordCount.new("I love Harambe and Harambe love me")
#      wc1.getWordCount()  # returns {"I"=>1, "love"=>2, "Harambe"=>2, "and"=>1, "me"=>1}
#      wc2 = WordCount.new("330 is best")
#      wc3 = WordCount.new("<3 going to class")
#      WordCount.getHistory()  # returns ["I love Harambe and Harambe love me", "330 is best", "<3 going to class"]
class WordCount
	@@history = []

	def initialize(sentence)
		@@history << sentence
		@words = sentence.split()
	end

	def getWordCount()
		# Notice that we use a default value for the Hash here
		# If we didn't, then we would have to worry about the case
		# where key doesn't exist in the hash
		count = Hash.new(0)

		for word in @words
  			count[word] = count[word] + 1
		end

		return count
	end

	def self.getHistory()
		return @@history
	end
end