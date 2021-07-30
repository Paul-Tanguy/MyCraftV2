module RecipesHelper
    def name(recipe)
        return "" if !recipe || !recipe.name
        mod, n = recipe.name.split(":").map(&:pretty)
        return "#{n} (mod: #{mod})"
    end

    def try(lambdas)
        lambdas.each do |l|
            begin
                return l[]
            rescue => exception
                0
            end
        end
        return "nothing worked bro"
    end

    def stacked(number)
        str = ""
        str += "#{number.to_i / 64} #{number >= 128 ? "stacks" : "stack"}" if number >= 64
        str += "#{number > 64 ? " + " : ""}#{(number == number.to_i ? number.to_i : number.round(3)) % 64}" if number % 64 != 0
        tmp = (number == number.to_i) ? number.to_i : number.round(3)
        str += " (#{human_readable(tmp)})" if number >= 64
        return str
    end

    def human_readable(obj)
        if obj.is_a?(Float) || obj.is_a?(Integer)
            #return obj if obj < 1000
            obj.ceil.to_s.chars.reverse.each_slice(3).map(&:join).map(&:reverse).reverse.join("'")
        end
    end

    def list_from_nested_array(array, is_last=true)
        material, quantity = array[0]

        content_tag(:ul) {
            ul_content = ""
            if array.size > 1
                ul_content << content_tag(:li, link_to("#{material == "forge:fe" ? human_readable(quantity) : stacked(quantity)} #{material.prettyM}", material.to_recipe))
                array[1].each.with_index do |child, i|
                    ul_content << list_from_nested_array(child, i + 1 >= array[1].size)
                end
            else
                ul_content << content_tag(:li, link_to("#{material == "forge:fe" ? human_readable(quantity) : stacked(quantity)} #{material.prettyM}", core_material_path(:id => 0, :material => material)), :class => "core")
            end
            ul_content.html_safe
        }.html_safe
    end
end