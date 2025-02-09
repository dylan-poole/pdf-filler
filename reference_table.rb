class ReferenceTable 
    attr_reader :entries
    def initialize(reference_table)
        @entries = []
        generate_entries(reference_table)
    end


    private

    def generate_entries(reference_table)
        reference_table.split("\n")[2..-1].each do |match|
            offset, generation_number, free = match.split(" ") 
            @entries << { offset: offset, generation_number: generation_number, free: free }
          end
    end
end