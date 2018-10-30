class Document
  def initialize(file)
    File.open("#{file}", "w") { |file|  }
  end
end