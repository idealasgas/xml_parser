require_relative 'Document'
require_relative 'CDATA'
require_relative 'Tag'
require_relative 'Declaration'
require_relative 'Comment'

class Parser
#binding.pry
  def initialize(filename)
    @tag_array = []
    @counter_tag = 0
    @comments_array = []
    @data_array = []
    @filename = filename
  end
  def print_file(file)
    puts "------  YOUR FILE -----"
    file.each do |line|
      puts line
    end
  end
  def parse
    IO.foreach(@filename) do |line|
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
  end
  def print_tree_view
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
  end
  def print_tag_counter
    puts "----- TAG COUNTER: #{@counter_tag} -----"
  end
  def print_declaration
    puts "----- DECLARATION -----"
    puts @declaration.data
    @tag_array = []
  end
  def print_comments
    puts "----- COMMENTS: -----"
    @comments_array.each do |comment|
      puts comment.text
    end
  end
  def print_cdata
    puts "----- CDATA: -----"
    @data_array.each do |data|
      puts data.data
    end
  end
end