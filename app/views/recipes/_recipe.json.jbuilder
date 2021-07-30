json.extract! recipe, :id, :name, :materials, :quantity, :extra, :priority, :image, :mod, :machine, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)
