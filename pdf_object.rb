class PdfObject

    attr_reader :id
    attr_reader :generation_number


    def initialize(object_string)
        @object_string = object_string
        @dictionary    = parse
    end


    def type
        @dictionary["Type"]
    end

    def to_s
        @dictionary.to_s
    end


    private

    def pdf_dict_to_hash(dict)
        result = {}
        dict.scan(/\/(\S+)\s+(.+)/) do |key, value|
            result[key] = value
        end

        result
    end

    def parse
        @id, @generation_number = @object_string.split("obj")[0].split(" ")
        object = @object_string.scan(/obj(.*?)endobj/m)
        pdf_dict_to_hash(object[0][0]) 
    end

end