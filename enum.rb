module Enumerable
    def my_each
        return to_enum(:my_select) unless block_given?

        for item in self
            yield item
        end
        self
    end

    def my_each_with_index
        return to_enum(:my_select) unless block_given?
        
        for i in 0...self.length
            yield(self[i], i)
        end
        self 
    end

    def my_select
        return to_enum(:my_select) unless block_given?
        new_array = []

        to_a.my_each do |item|
            if yield(item)
                new_array.push(item)
            end
        end
        new_array
    end

    def my_all?(arg = nil)
        result = true

        if(!arg.nil?)
            my_each do |item|
                result = false unless arg === item
            end
        elsif !block_given?
            my_each do |item|
                result = false unless item
            end
        else
            my_each do |item|
                result = false unless yield(item)
            end
        end

        result
    end

    def my_any?(arg =nil)
        result = false

        if !arg.nil?
            my_each do |item|
                result = true if arg === item
            end
        elsif !block_given?
            my_each do |item|
                result = true if item
            end
        end

        result
    end

    def my_none?(arg = nil)
        result = true

        if(!arg.nil?)
            my_each do |item|
                result = false if arg === item
            end
        elsif !block_given?
            my_each do |item|
                result = false if item
            end
        else
            my_each do |item|
                result = false if yield(item)
            end
        end

        result
    end

    def my_count(arg= nil)
        count = 0

        if !arg.nil?
            my_each do |item|
                count += 1 if arg === item
            end
        elsif !block_given?
            my_each do |item|
                count += 1 
            end
        else
            my_each do |item|
                count += 1 if yield(item)
            end
        end
        count
    end

    def my_map(proc = nil)
        return to_enum(:my_map) unless proc.is_a?(Proc) || block_given?

        new_array = []
        if !proc.nil? && proc.is_a?(Proc)
            my_each do |item|
                new_array.push(proc.call(item))
            end
        else 
            my_each do |item|
                new_array.push(yield(item))
            end
        end
       
        new_array
    end

    def my_inject(*args)
        accumulator = args[0] if args[0].is_a?(Integer)

        if args[0].is_a?(Symbol) 
            symbol = args[0]
            my_each do |item|
                accumulator = accumulator ? accumulator.send(symbol, item) : item
            end

        elsif(args[0].is_a?(Integer) && args[1].is_a?(Symbol))
            symbol = args[1]
           my_each do |item|
            accumulator = accumulator ? accumulator.send(symbol, item) : item
           end
        else
            my_each do |item|
               accumulator = accumulator ? yield(accumulator, item) : item
            end 
        end

        accumulator
    end
end


def multiply_els(arg)
    return arg.my_inject do |acc, item|
        acc + item
    end
end
