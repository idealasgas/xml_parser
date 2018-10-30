require 'pry'
require_relative 'Document'
require_relative 'CDATA'
require_relative 'Tag'
require_relative 'Declaration'
require_relative 'Comment'

filename = 'xml_example.xml'
file = File.open(filename)

puts "------  YOUR FILE -----"
file.each do |line|
  puts line
end

@tag_array = []
@counter_tag = 0
@comments_array = []
@data_array = []

#binding.pry
IO.foreach(filename) do |line|
  #комментарий
  if line.match(/<!-- (([a-z])*(\s)?)* -->/)
    comment = Comment.new(line)
    @comments_array.push(comment)
  end
  #открывающийся тег
  if line.match(/(?<!<!\[CDATA\[)<([a-z]*(\s)?)*>/)
    @counter_tag += 1
    @tag_array.push(line.match(/<([a-z]*(\s)?)*>/)[0])
  end
  #закрывающийся тег
  if line.match(/<\/([a-z]*(\s)?)*>(?!\]\]>)/)
    @tag_array.push(line.match(/<\/([a-z]*(\s)?)*>/)[0])
  end
  #однострочный тег
  if line.match(/<([a-z]*(\s)?)*>([a-z]*(\s)?)*<\/([a-z]*(\s)?)*>/)
    @counter_tag += 1
    @tag_array.push(line.match(/<([a-z]*(\s)?)*>/)[0])
    @tag_array.push(line.match(/<\/([a-z]*(\s)?)*>/)[0])
  end
  #CDATA
  if line.match(/<!\[CDATA\[([\s\S])*\]\]>/)
    data = CDATA.new(line)
    @data_array.push(data)
  end
  #инструкция обработки
  if line.match(/<\?[\s\S]*\?>/)
    #puts 'инструкция обработки'
    @declaration = Declaration.new(line)
  end
end

puts "----- TREE VIEW -----"
#древовидное представление
@spaces = 0
@tag_array.each do |tag|
  if tag.match(/<\/([a-z]*(\s)?)*>/)
    @spaces -= 1
  end
  @spaces.times do
    print '  '
  end
  print "#{tag}\n"
  if tag.match(/<([a-z]*(\s)?)*>/)
    @spaces += 1
  end
end

puts "----- TAG COUNTER: #{@counter_tag} -----"

puts "----- DECLARATION -----"
puts @declaration.data
@tag_array = []

puts "----- COMMENTS: -----"
@comments_array.each do |comment|
  puts comment.text
end

puts "----- CDATA: -----"
@data_array.each do |data|
  puts data.data
end