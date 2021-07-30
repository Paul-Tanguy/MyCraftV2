module ApplicationHelper
    def debug(obj, c="*")
        p c*123
        p obj
        p c*123
    end
end

class String
    def pretty()
        self.split("_").map(&:capitalize).join(" ")
    end

    def prettyM()
        mod, material = self.split(":")
        return "" if !mod
        return mod.pretty if !material
        material.split("_").map{|x| x.upcase != x ? x.capitalize : x}.join(" ") + " (#{mod})"
    end

    def to_materials(quantity = 1.0)
        self.split("\r\n").map{|x| a,b=x.split(" "); [a, b.to_f * quantity]}
    end

    def to_recipe()
        Recipe.order(:priority).where(:name => self)[0]
    end

    def to_field()
        {
            :string => :text_field,
            :text => :text_area,
            :float => :text_field,
            :integer => :number_field,
        }[self.to_sym] || :text_area
    end
end