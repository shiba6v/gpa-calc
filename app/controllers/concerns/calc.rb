class InvalidPDFError < StandardError; end
module State
  # 評価
  WAITING_GRADE = 0
  PROCESSING_GRADE = 1
  # 単位数
  PROCESSING_CREDIT = 2
end

module Consts
  GRADE = ["A+", "A", "B", "C", "D", "F", "P"]
  NO_COUNT = -1
end

module Calculator
def calc pdf
pdf_utf8 = pdf.force_encoding("utf-8")
File.write('seiseki.pdf', pdf_utf8)
pdf_content = `pdftotext -enc UTF-8 seiseki.pdf -`

# 授業数
@gpa.ap_amount = 0
@gpa.a_amount = 0
@gpa.b_amount = 0
@gpa.c_amount = 0
@gpa.d_amount = 0
@gpa.f_amount = 0

line_index = 0

state = State::WAITING_GRADE

grades = []
credits = []

pdf_content.each_line do |line_raw|
  line_index += 1
  line = line_raw.chomp

  # 改行文字を含めないで1か2文字になるはず．
  if line.length > 2
    next
  end

  if state == State::WAITING_GRADE && Consts::GRADE.include?(line)
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
      grades.push Consts::NO_COUNT
    else
      state = State::PROCESSING_CREDIT
    end

    puts "grade:" + line if line != ""

  elsif state == State::PROCESSING_CREDIT
    case line
    when "" then
      state = State::WAITING_GRADE
			# とりあえず位置をそろえるが，Fで単位数が空白の時に変な挙動をする
      puts credits.length
			puts grades.length
			grades.slice!(credits.length - 1, grades.length - credits.length)
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
@gpa.credit_sum = credits.inject(:+)

for i in 0...length do
  if grades[i] == Consts::NO_COUNT
    next
  end
  point_sum += grades[i] * credits[i]
end

puts "point_sum:" + point_sum.to_s
puts "credit_sum:" + @gpa.credit_sum.to_s

@gpa.gpa = point_sum.to_f / (@gpa.credit_sum - grades.count(Consts::NO_COUNT))
puts "gpa:" + @gpa.gpa.to_s
end
end
