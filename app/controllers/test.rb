def solution(angles)
	less = 0
	more = 0
	beg = 0
	fin = 0

	angles.split("").each do |angle|
		if angle == ">"
			more += 1
		elsif angle == "<"
			less += 1
		end

		if more > less
			beg += 1
			more == 0
			less == 0
		end
	end

	less = 0
	more = 0
	angles.split("").each do |angle|
		if angle == ">"
			more += 1
		elsif angle == "<"
			less += 1
		end

		if less > more
		fin += 1
		more == 0
		less == 0
		end
	end


	

	res = ("<" * beg) + angles

	if fin > 0
		res = res + (">" * fin)
	end

	res
end

puts solution("<<<")