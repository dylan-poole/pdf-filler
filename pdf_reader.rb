require_relative "reference_table"
require_relative "pdf_object"

class PdfRead

  attr_reader :objects

  def initialize(file_path)
    file =  File.open(file_path, "rb")
    @pdf_data = file.read
    @objects = {}
    file.close
    parse
  end


  def reference_table_offset
    @pdf_data.match(/^startxref\s+(\d+)\s+%%EOF$/)[1].to_i
  end


  # Rename this method. 
  def read_reference_table
    object_strs = []
    reference_table = @pdf_data[reference_table_offset...@pdf_data.index("trailer")]
    ReferenceTable.new(reference_table).entries.each do |entry|
      # Here is an example of why entries might need to be their own objects....
      offset = entry["offset"]
      # TODO find a better way, I don't like the idea of going to the last index in the array
      remaining_data = @pdf_data[offset..-1]  
      endobj_index = remaining_data.index("endobj")
      object_data = remaining_data[0..endobj_index + 5]
      object_strs << object_data
    end
    object_strs
  end


private

  def parse
    create_objects(read_reference_table)
  end

  def create_objects(object_strings)
    object_strings.each do |str| 
      pdf_object = PdfObject.new(str)
      # Bleh deal with generation numbers later...
      if @objects[pdf_object.id].nil?
        @objects[pdf_object.id] = [pdf_object]
      else
        @objects[pdf_object.id] << pdf_object
      end
    end
  end
end

PdfRead.new("example.pdf")

