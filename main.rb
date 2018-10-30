require 'pry'
class Document
  def initialize(file)
    File.open("#{file}", "w") { |file|  }
  end
end
filename = 'xml_example.xml'
file = File.open(filename)

puts "------  YOUR FILE -----"
file.each do |line|
  puts line
end

class CDATA
  attr_accessor :data
  def initialize(line)
    @data = line.match(/(?<=<!\[CDATA\[)([\s\S]*)(?=\]\]>)/)[0]
  end
end

#ОПИСАНИЕ ТЕГА
class Tag
  attr_accessor :name, :tags, :content
  def initialize(name)
    @name = name
    @tags = []
    @content = []
  end
  def find_nested_tags
    @content.each do |line|
      binding.pry
      if (line.match(/<([a-z]*(\s)?)*>/) && @inner_tag.nil?)
        @inner_tag = Tag.new(/(([a-z])*(\s)?)*(?=>)/.match(line)[0])
        @tags.push(@inner_tag)
      end
      if (line.match(/<\/([a-z]*(\s)?)*>/) && (/(?<=\/)((([a-z])*(\s)?)*)(?=>)/.match(line)[0] == @inner_tag.name))
        @inner_tag.find_nested_tags
        @inner_tag = nil
      end
      unless @inner_tag.nil?
        @inner_tag.content.push(line)
      end
    end
  end
end

class Declaration
  attr_accessor :data
  def initialize(line)
    @data = line
  end
end

class Comment
  attr_accessor :text
  def initialize(line)
    @text = line.match(/(?<=<!--\s)(([a-z])*(\s)?)*/)[0]
  end
end

#@tracker = []
#@current_tag
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
#puts @counter_tag
@tag_array = []


#for element in (1..@counter_tag) do
 # tag = 0
  #IO.foreach(filename) do |line|
    #binding.pry
   # if line.match(/<(\w(\s)?)*>\n/)
    #  tag += 1
    #end
    #if line.match(/<(\w(\s)?)*>\n/) && tag == element
     # @current_tag = Tag.new(line.match(/<([a-z]*(\s)?)*>/)[0])
      #@tag_array.push(@current_tag)
    #end
    #if tag == element
     # @current_tag.content.push(line)
    #end
    #if line.match(/<\/(\w(\s)?)*>/)
     # if line.match(/\w/)[0] == @current_tag.name.match(/\w/)[0]
      #  next
      #end
    #end
  #end
#end

#binding.pry
#@tag_array.each do |tag|
 # puts tag.content
#end
#binding.pry
puts "----- COMMENTS: -----"
@comments_array.each do |comment|
  puts comment.text
end

puts "----- CDATA: -----"
@data_array.each do |data|
  puts data.data
end