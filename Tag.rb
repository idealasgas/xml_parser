class Tag
  attr_accessor :name, :tags, :content
  def initialize(name)
    @name = name
    @tags = []
    @content = []
  end
end