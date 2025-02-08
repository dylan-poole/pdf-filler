class PdfRead

  def initialize(file_path)
    file =  File.open(file_path, "rb")
    @pdf_data = file.read
    @objects = []
    file.close
    get_reference_table
  end


  def reference_table_offset
    @pdf_data.match(/^startxref\s+(\d+)\s+%%EOF$/)[1].to_i
  end

  def get_reference_table
    reference_table = @pdf_data[reference_table_offset...@pdf_data.index("trailer")]
    reference_table.split("\n")[2..-1].each do |match|
      offset = match.split(" ")[0].to_i 
      # TODO find a better way, I don't like the idea of going to the last index in the array
      remaining_data = @pdf_data[offset..-1]  
    
      endobj_index = remaining_data.index("endobj")
      object_data = remaining_data[0..endobj_index + 5]
      # Future update, make an object class
      @objects << object_data
    end
  end

  def read_objects
    p @objects
  end
end

PdfRead.new("example.pdf").read_objects
