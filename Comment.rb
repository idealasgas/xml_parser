class Comment
  attr_accessor :text
  def initialize(line)
    @text = line.match(/(?<=<!--\s)(([a-z])*(\s)?)*/)[0]
  end
end