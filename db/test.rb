class InvalidPDFError < StandardError; end
module State
  # 評価
  WAITING_GRADE = 0
  PROCESSING_GRADE = 1
  # 単位数
  PROCESSING_CREDIT = 2
end

module Calculator
  private
  def Calc
# echoにかえる
pdf_content = `cat seiseki.pdf | pdftotext -enc UTF-8 - seiseki.txt | cat seiseki.txt`

GRADE = ["A+", "A", "B", "C", "D", "F", "P"]

# 授業数
@gpa.ap_amount = 0
@gpa.a_amount = 0
@gpa.b_amount = 0
@gpa.c_amount = 0
@gpa.d_amount = 0
@gpa.f_amount = 0

line_index = 0

state = State::WAITING_GRADE

NO_COUNT = -1
grades = []
credits = []

pdf_content.each_line do |line_raw|
  line_index += 1
  line = line_raw.chomp

  # 改行文字を含めないで1か2文字になるはず．
  if line.length > 2
    next
  end

  if state == State::WAITING_GRADE && GRADE.include?(line)
    state = State::PROCESSING_GRADE
  end

  if state == State::PROCESSING_GRADE

    case line
    when "A+" then
      grades.push 4.3
      @gpa.ap_amount += 1
    when "A" then
      grades.push 4
      @gpa.a_amount +=1
    when "B" then
      grades.push 3
      @gpa.b_amount +=1
    when "C" then
      grades.push 2
      @gpa.c_amount +=1
    when "D" then
      grades.push 1
      @gpa.d_amount +=1
    when "F" then
      grades.push 0
      @gpa.f_amount +=1
    when "P" then
      grades.push NO_COUNT
    else
      state = State::PROCESSING_CREDIT
    end

    puts "grade:" + line if line != ""

  elsif state == State::PROCESSING_CREDIT

    case line
    when "" then
      state = State::WAITING_GRADE
      if grades.length != credits.length
        raise InvalidPDFError
      end
    else
      credits.push line.to_i
      puts "credit:" + line if line != ""

    end

  end

end

length = grades.length
point_sum = 0
@gpa.credit_sum = credits.inject(:+) - grades.count(NO_COUNT)

for i in 0...length do
  if grades[i] == NO_COUNT
    next
  end
  point_sum += grades[i] * credits[i]
end

puts "point_sum:" + point_sum.to_s
puts "credit_sum:" + credit_sum.to_s

@gpa.gpa = point_sum.to_f / credit_sum
puts "gpa:" + gpa.to_s
end
end



